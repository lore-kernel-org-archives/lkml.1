Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbZABRWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbZABRWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbZABRWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:22:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34542 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbZABRWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:22:10 -0500
Date: Fri, 2 Jan 2009 18:21:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mpparse.c fix style problems
Message-ID: <20090102172150.GC6759@elte.hu>
References: <1230723533.3738.8.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230723533.3738.8.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Impact: cleanup, fix style problems, more readable

> @@ -314,7 +314,9 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
>  		return 1;
>  
>  	if (mpc->mpc_oemptr && x86_quirks->smp_read_mpc_oem) {
> -		struct mp_config_oemtable *oem_table = (struct mp_config_oemtable *)(unsigned long)mpc->mpc_oemptr;
> +		struct mp_config_oemtable *oem_table;
> +		oem_table = (struct mp_config_oemtable *)
> +			     (unsigned long)mpc->mpc_oemptr;
>  		x86_quirks->smp_read_mpc_oem(oem_table, mpc->mpc_oemsize);
>  	}

i think it would be cleaner to rename all the the mpc->mpc_X fields to 
mpc->X - that alone would give 4 characters per usage site. (we already 
know that it's an 'mpc' entity - no need to duplicate that in the field 
too)

likewise, mp_config_oemtable should be renamed to mpc_oemtable to make it 
all more compact.

also, instead of:

> +		struct mp_config_oemtable *oem_table;
> +		oem_table = (struct mp_config_oemtable *)
> +			     (unsigned long)mpc->mpc_oemptr;

we can do this oneliner:

> +		struct mpc_oemtable oem_table = (void *)(long)mpc->mpc_oemptr;

these types of printk string tweaks:

> -				printk(KERN_INFO "No spare slots, try to append...take your risk, new mpc_length %x\n", count);
> +				printk(KERN_INFO "No spare slots, try to append"
> +				       "...take your risk, new mpc_length %x\n",
> +				       count);

do not actually improve the result - as they break the string in about 40 
columns - making grepping harder and making it less readable. So it's a 
step backwards.

To solve the 80 columns wrap problem, the following could be and should be 
done instead.

1) get the type names right - they should be expressive but short - like a 
   good Huffman encoding:

See the mpc_ suggestion above, but there are more examples as well:

				struct mpc_config_processor *m =
				    (struct mpc_config_processor *)mpt;

mpc_config_processor should be renamed to mpc_cpu. The reason: the 'c' in 
MPC already means 'config' - no need to repeat that in the type name. Plus 
'processor' is a lot longer than 'cpu' - so we try to use 'cpu' in all 
type names, as much as possible.

2) get the code flow granularity right. Use small but expressive 
   functions, where each function does one well-defined thing that is easy 
   to think about as one unit of activity.

For example observe that replace_intsrc_all() is too big and not 
particularly well structured.

furthermore, the whole function could be split up with a few helper 
functions. Most of the loops could be split up by doing something like:

        while (count < mpc->mpc_length) {
		switch (*mpt) {

		case MP_PROCESSOR:
			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
			continue;

		case MP_BUS:
			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
			continue;

		[...]
		case MP_INTSRC:
			parse_mpc_irq_entry(&mpt, &count);
			continue;

		default:
			...
			goto out;
	}

The whole thing is way more readable, and it's immediately obvious that 
the real work is done by MP_INTSRC - in a separate helper function. The 
skip_entry() helper function just skips over

3) Get the details right. Look at the source code - should that code be
   done like that and does it look as compact as it could be?

for example these bits:

	while (count < mpc->mpc_length) {
		switch (*mpt) {
		case MP_PROCESSOR:
			{
				struct mpc_config_processor *m =
				    (struct mpc_config_processor *)mpt;
				mpt += sizeof(*m);
				count += sizeof(*m);
				break;
			}
		case MP_BUS:

are _way_ too wasteful with tabs - and that is causing the 80 cols 
problems. (we'd fix this if we hadnt fixed it at step 2 already ;-)

Or these bits:

---------------->
static int  __init replace_intsrc_all(struct mp_config_table *mpc,
					unsigned long mpc_new_phys,
					unsigned long mpc_new_length)
{
#ifdef CONFIG_X86_IO_APIC
	int i;
	int nr_m_spare = 0;
#endif

	int count = sizeof(*mpc);
	unsigned char *mpt = ((unsigned char *)mpc) + count;
<----------------

are more readable as:

---------------->
static int  __init
replace_intsrc_all(struct mpc_table *mpc,
		   unsigned long mpc_new_phys,
		   unsigned long mpc_new_length)
{
	unsigned char *mpt = (void *)mpc;
	int count = 0;

	skip_entry(&mpt, &count, sizeof(struct mpc_table));
<----------------

we were able to do this because we introduced the skip_entry() helper that 
can be used for the initial mpc_table skip, and we were also able to 
remove the ugly #ifdef IO_APIC variable section because the totality of 
the MP_INTSRC parsing code moved into a helper function.

The same principles can be applied to this loop:

#ifdef CONFIG_X86_IO_APIC
	for (i = 0; i < mp_irq_entries; i++) {
		if (irq_used[i])
			continue;

all without changing any functionality of the code. The end result will be 
day and light to what we had before.

Would you be interested in doing these cleanups? Ideally they should be 
done as a series of 5-10 patches - with a single conceptual cleanup per 
patch.

	Ingo
