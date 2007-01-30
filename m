Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbXA3WyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbXA3WyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXA3WyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:54:10 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34477 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbXA3WyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:54:08 -0500
Message-ID: <45BFCC8E.4000008@us.ibm.com>
Date: Tue, 30 Jan 2007 16:54:06 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
CC: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for profiling
 Cell BE SPUs -- update
References: <45BE4ED0.5030808@us.ibm.com> <45BE4FA4.9020105@us.ibm.com> <200701300839.05144.arnd@arndb.de> <45BFBB78.7060907@us.ibm.com>
In-Reply-To: <45BFBB78.7060907@us.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maynard Johnson wrote:

> Arnd Bergmann wrote:
> 
> 
>>On Monday 29 January 2007 20:48, Maynard Johnson wrote:
>>
>>
>>>Subject: Add support to OProfile for profiling Cell BE SPUs
>>>
>>>From: Maynard Johnson <maynardj@us.ibm.com>
>>>
>>>This patch updates the existing arch/powerpc/oprofile/op_model_cell.c
>>>to add in the SPU profiling capabilities.  In addition, a 'cell' subdirectory
>>>was added to arch/powerpc/oprofile to hold Cell-specific SPU profiling
>>>code.
>>>
>>>Signed-off-by: Carl Love <carll@us.ibm.com>
>>>Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>
>>
[snip]
>>
>>>+ * 
>>>+ * Ideally, we would like to be able to create the cached_info for
>>>+ * an SPU task just one time -- when libspe first loads the SPU 
>>>+ * binary file.  We would store the cached_info in a list.  Then, as
>>>+ * SPU tasks are switched out and new ones switched in, the cached_info
>>>+ * for inactive tasks would be kept, and the active one would be placed
>>>+ * at the head of the list.  But this technique may not with
>>>+ * current spufs functionality since the spu used in bind_context may
>>>+ * be a different spu than was used in a previous bind_context for a
>>>+ * reactivated SPU task.  Additionally, a reactivated SPU task may be
>>>+ * assigned to run on a different physical SPE.  We will investigate
>>>+ * further if this can be done.
>>>+ *
>>>+ */
>>
>>
>>You should stuff a pointer to cached_info into struct spu_context,
>>e.g. 'void *profile_private'.
>>
>>
>>
>>>+struct cached_info {
>>>+       vma_map_t * map;
>>>+       struct spu * the_spu;
>>>+       struct kref cache_ref;
>>>+       struct list_head list;
>>>+};
>>
>>
>>And replace the 'the_spu' member with a back pointer to the
>>spu_context if you need it.
>>
>>
>>
>>>+
>>>+/* A data structure for cached information about active SPU tasks.
>>>+ * Storage is dynamically allocated, sized as
>>>+ * "number of active nodes multplied by 8". 
>>>+ * The info_list[n] member holds 0 or more 
>>>+ * 'struct cached_info' objects for SPU#=n. 
>>>+ *
>>>+ * As currently implemented, there will only ever be one cached_info 
>>>+ * in the list for a given SPU.  If we can devise a way to maintain
>>>+ * multiple cached_infos in our list, then it would make sense
>>>+ * to also cache the dcookie representing the PPU task application.
>>>+ * See above description of struct cached_info for more details.
>>>+ */
>>>+struct spu_info_stacks {
>>>+       struct list_head * info_list;
>>>+};
>>
>>
>>Why do you store pointers to list_head structures? If you want to store
>>lists, you should have a lists_head itself in here.
> 
> info_list is an array of n lists, where n is the number of SPUs.
> 
>>Why do you store them per spu in the first place? The physical spu
>>doesn't have any relevance to this at all, the only data that is
>>per spu is the sample data collected on a profiling interrupt,
>>which you can then copy in the per-context data on a context switch.
> 
> The sample data is written out to the event buffer on every profiling 
> interrupt.  But we don't write out the SPU program counter samples 
> directly to the event buffer.  First, we have to find the cached_info 
> for the appropriate SPU context to retrieve the cached vma-to-fileoffset 
> map.  Then we do the vma_map_lookup to find the fileoffset corresponding 
> to the SPU PC sample, which we then write out to the event buffer.  This 
> is one of the most time-critical pieces of the SPU profiling code, so I 
> used an array to hold the cached_info for fast random access.  But as I 
> stated in a code comment above, the negative implication of this current 
> implementation is that the array can only hold the cached_info for 
> currently running SPU tasks.  I need to give this some more thought.

I've given this some more thought, and I'm coming to the conclusion that 
a pure array-based implementation for holding cached_info (getting rid 
of the lists) would work well for the vast majority of cases in which 
OProfile will be used.  Yes, it is true that the mapping of an SPU 
context to a phsyical spu-numbered array location cannot be guaranteed 
to stay valid, and that's why I discard the cached_info at that array 
location when the SPU task is switched out.  Yes, it would be terribly 
inefficient if the same SPU task gets switched back in later and we 
would have to recreate the cached_info.  However, I contend that 
OProfile users are interested in profiling one application at a time. 
They are not going to want to muddy the waters with multiple SPU apps 
running at the same time.  I can't think of any reason why someone would 
conscisouly choose to do that.

Any thoughts from the general community, especially OProfile users?

Thanks.
-Maynard
> 
>>
[snip]

