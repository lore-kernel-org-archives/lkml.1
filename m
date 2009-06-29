Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbZF2VHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbZF2VHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZF2VHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:07:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43918 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbZF2VHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:07:16 -0400
Message-ID: <4A492D86.5040604@redhat.com>
Date: Mon, 29 Jun 2009 17:09:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: Re: [RFC][ PATCH -tip v2 2/7] kprobes: introducing generic insn_slot
  framework
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <20090622212307.5384.41192.stgit@localhost.localdomain> <alpine.DEB.2.00.0906271558140.12592@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0906271558140.12592@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for reviewing.

Steven Rostedt wrote:
> Hi Masami,
> 
> I'm currently traveling so my responses are very slow this week.
> 
> 
> On Mon, 22 Jun 2009, Masami Hiramatsu wrote:
> 
>> Make insn_slot framework support various size slots.
>> Current insn_slot just supports one-size instruction buffer slot. However,
>> kprobes jump optimization needs larger size buffers.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Jim Keniston <jkenisto@us.ibm.com>
>> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Anders Kaseorg <andersk@ksplice.com>
>> Cc: Tim Abbott <tabbott@ksplice.com>
>> ---
>>
>>  kernel/kprobes.c |   96 +++++++++++++++++++++++++++++++++---------------------
>>  1 files changed, 58 insertions(+), 38 deletions(-)
>>
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index 0b68fdc..bc9cfd0 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -100,26 +100,38 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
>>   * stepping on the instruction on a vmalloced/kmalloced/data page
>>   * is a recipe for disaster
>>   */
>> -#define INSNS_PER_PAGE	(PAGE_SIZE/(MAX_INSN_SIZE * sizeof(kprobe_opcode_t)))
>> -
>>  struct kprobe_insn_page {
>>  	struct list_head list;
>>  	kprobe_opcode_t *insns;		/* Page of instruction slots */
>> -	char slot_used[INSNS_PER_PAGE];
>>  	int nused;
>>  	int ngarbage;
>> +	char slot_used[1];
> 
> I would recommend using [] instead of [1], that would help other 
> developers know that it is a variable array.

Sure.

[...]
>> -	list_for_each_entry(kip, &kprobe_insn_pages, list) {
>> -		if (kip->nused < INSNS_PER_PAGE) {
>> +	list_for_each_entry(kip, &c->pages, list) {
>> +		if (kip->nused < slots_per_page(c)) {
>>  			int i;
>> -			for (i = 0; i < INSNS_PER_PAGE; i++) {
>> +			for (i = 0; i < slots_per_page(c); i++) {
>>  				if (kip->slot_used[i] == SLOT_CLEAN) {
>>  					kip->slot_used[i] = SLOT_USED;
>>  					kip->nused++;
>> -					return kip->insns + (i * MAX_INSN_SIZE);
>> +					return kip->insns + (i * c->insn_size);
>>  				}
>>  			}
>> -			/* Surprise!  No unused slots.  Fix kip->nused. */
>> -			kip->nused = INSNS_PER_PAGE;
>> +			/* kip->nused is broken. */
>> +			BUG();
> 
> Does this deserve a bug, or can we get away with a WARN and find a way to 
> fail nicely? Is it already too late to recover?

No, WARN() is enough here.

> 
>>  		}
>>  	}
>>  
>>  	/* If there are any garbage slots, collect it and try again. */
>> -	if (kprobe_garbage_slots && collect_garbage_slots() == 0) {
>> +	if (c->nr_garbage && collect_garbage_slots(c) == 0)
>>  		goto retry;
>> -	}
>> +
>>  	/* All out of space.  Need to allocate a new page. Use slot 0. */
>> -	kip = kmalloc(sizeof(struct kprobe_insn_page), GFP_KERNEL);
>> +	kip = kmalloc(sizeof(struct kprobe_insn_page) + slots_per_page(c) - 1,
> 
> Why the '- 1'?  Is it because of the char [1] above?
> 
> Would be better to make the size of the kprobe_insn_page a macro:
> 
> #define KPROBE_INSN_SIZE offsetof(struct kbrobe_insn_page, slot_used)
> 
> and then you can do the following:
> 
> 	kip = kmalloc(KPROBE_INSN_SIZE + slots_per_page(c));

Good idea!

Thanks


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

