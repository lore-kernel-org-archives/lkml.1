Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXA3XbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXA3XbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbXA3XbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:31:13 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46014 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbXA3XbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:31:12 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for
	profiling Cell BE SPUs -- update
From: Carl Love <cel@us.ibm.com>
To: maynardj@us.ibm.com
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <45BFBB78.7060907@us.ibm.com>
References: <45BE4ED0.5030808@us.ibm.com> <45BE4FA4.9020105@us.ibm.com>
	 <200701300839.05144.arnd@arndb.de>  <45BFBB78.7060907@us.ibm.com>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 15:31:09 -0800
Message-Id: <1170199869.5235.38.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 15:41 -0600, Maynard Johnson wrote:
[snip
> [snip]
> >>+       // process the collected SPU PC for each node
> >>+       for_each_online_cpu(cpu) {
> >>+               if (cbe_get_hw_thread_id(cpu))
> >>+                       continue;
> >>+
> >>+               node = cbe_cpu_to_node(cpu);
> >>+               node_factor = node * SPUS_PER_NODE;
> >>+                /* number of valid entries for this node */
> >>+               entry = 0;
> >>+
> >>+               trace_addr = cbe_read_pm(cpu, trace_address);
> >>+               while ((trace_addr & CBE_PM_TRACE_BUF_EMPTY) != 0x400)
> >>+               {
> >>+                       /* there is data in the trace buffer to process */
> >>+                       cbe_read_trace_buffer(cpu, trace_buffer);  
> >>+                       spu_mask = 0xFFFF000000000000;
> >>+
> >>+                       /* Each SPU PC is 16 bits; hence, four spus in each of 
> >>+                        * the two 64-bit buffer entries that make up the
> >>+                        * 128-bit trace_buffer entry.  Process the upper and
> >>+                        * lower 64-bit values simultaneously.
> >>+                        */
> >>+                       for (spu = 0; spu < SPUS_PER_TB_ENTRY; spu++) {
> >>+                               spu_pc_lower = spu_mask & trace_buffer[0];
> >>+                               spu_pc_lower = spu_pc_lower >> (NUM_SPU_BITS_TRBUF
> >>+                                                               * (SPUS_PER_TB_ENTRY-spu-1));
> >>+
> >>+                               spu_pc_upper = spu_mask & trace_buffer[1];
> >>+                               spu_pc_upper = spu_pc_upper >> (NUM_SPU_BITS_TRBUF
> >>+                                                               * (SPUS_PER_TB_ENTRY-spu-1));
> >>+
> >>+                               spu_mask = spu_mask >> NUM_SPU_BITS_TRBUF;
> >>+
> >>+                               /* spu PC trace entry is upper 16 bits of the
> >>+                                * 18 bit SPU program counter 
> >>+                                */
> >>+                               spu_pc_lower = spu_pc_lower << 2;
> >>+                               spu_pc_upper = spu_pc_upper << 2;
> >>+
> >>+                               samples[((node_factor + spu) * TRACE_ARRAY_SIZE) + entry]
> >>+                                       = (u32) spu_pc_lower;
> >>+                               samples[((node_factor + spu + SPUS_PER_TB_ENTRY) * TRACE_ARRAY_SIZE) + entry]
> >>+                                       = (u32) spu_pc_upper;
> >>+                       }
> >>+
> >>+                       entry++;
> >>+
> >>+                       if (entry >= TRACE_ARRAY_SIZE) 
> >>+                               /* spu_samples is full */
> >>+                               break;
> >>+
> >>+                       trace_addr = cbe_read_pm(cpu, trace_address);
> >>+               }
> >>+               samples_per_node[node] = entry;
> >>+       }
> >>+}
> > 
> > 
> > While I can't see anything technically wrong with this function, it would be
> > good to split it into smaller functions. Since you are nesting three
> > loops, it should be possible to make a separate function from one of the
> > inner loops without changing the actual logic behind it.
> Will do.
> > 
> > 
> >>+
> >>+static int profile_spus(struct hrtimer * timer)
> >>+{
> >>+       ktime_t kt;
> >>+        int cpu, node, k, num_samples, spu_num;
> > 
> > 
> > whitespace damage
> fixed
> > 
> > 
> >>+       
> >>+       if (!spu_prof_running)
> >>+               goto STOP;
> >>+
> >>+       cell_spu_pc_collection();
> >>+       for_each_online_cpu(cpu) {
> >>+               if (cbe_get_hw_thread_id(cpu))
> >>+                       continue;
> > 
> > 
> > Here, you enter the same top-level loop again, why not make it
> > 	for_each_online_cpu(cpu) {
> > 		if (cbe_get_hw_thread_id(cpu))
> >                          continue;
> > 		num_samples = cell_spu_pc_collection(cpu);
> > 		...
> Yes, good suggestion.
I believe what you are asking here is why can't the
cell_spu_pc_collection() function put the data in to the samples array
for a given node, in the loop that then processes the samples array for
that node.  Yes, I believe that this can be done.  The only restriction
is that cell_spu_pc_collection() will have to extract the SPU program
counter data for all SPUs on that node.  This is due to the fact the
data for the 8 SPUs are all stored in a single entry of the hardware
trace buffer.  Once the hardware trace buffer is read, the hardware
advances the read pointer so there is no way to go back and re-read the
entry.

[snip]


[snip]
> >>+static int calculate_lfsr(int n)
> >>+{
> >>+#define size 24
> >>+       int i;
> >>+       unsigned int newlfsr0;
> >>+       unsigned int lfsr = 0xFFFFFF;
> >>+       unsigned int howmany = lfsr - n;
> >>+
> >>+       for (i = 2; i < howmany + 2; i++) {
> >>+               newlfsr0 = (((lfsr >> (size - 1 - 0)) & 1) ^
> >>+                           ((lfsr >> (size - 1 - 1)) & 1) ^
> >>+                           (((lfsr >> (size - 1 - 6)) & 1) ^
> >>+                            ((lfsr >> (size - 1 - 23)) & 1)));
> >>+
> >>+               lfsr >>= 1;
> >>+               lfsr = lfsr | (newlfsr0 << (size - 1));
> >>+       }
> >>+       return lfsr;
> >>+
> >>+}
> > 
> > 
> > I don't have the slightest idea what this code is about, but
> Me neither.  Carl, can you comment?
> > it certainly looks inefficient to loop 16 million times to
> > compute a constant. Could you use a faster algorithm instead,
> > or at least add a comment about why you do it this way?
> > 
> > 

An LFSR sequence is similar to a pseudo random number sequence. For a 24
bit LFSR sequence each number between 0 and 2^24 will occur once in the
sequence but not in a normal counting order.  The hardware uses the LFSR
sequence to count to since it is much simpler to implement in hardware
then a normal counter.  Unfortunately, the only way we know how to
figure out what the LFSR value that corresponds to the number in the
sequence that is N before the last value (0xFFFFFF) is to calculate the
previous value N times.  It is like trying to ask what is the pseudo
random number that is N before this pseudo random number?

I will add a short comment to the code that will summarize the above
paragraph.
[snip]

