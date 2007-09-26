Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbXIZIfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbXIZIfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbXIZIe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:34:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbXIZIez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:34:55 -0400
Date: Wed, 26 Sep 2007 10:34:53 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       kexec@lists.infradead.org, akpm@linux-foundation.org
Subject: Re: [patch 1/7] Extended crashkernel command line
Message-ID: <20070926083453.GE11385@suse.de>
Mail-Followup-To: Oleg Verych <olecom@flower.upol.cz>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	kexec@lists.infradead.org, akpm@linux-foundation.org
References: <20070925182257.900701776@strauss.suse.de> <20070925182258.175348676@strauss.suse.de> <E1IaHPU-00089b-Bc@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IaHPU-00089b-Bc@flower>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Verych <olecom@flower.upol.cz> [2007-09-25 22:53]:
> * Tue, 25 Sep 2007 20:22:58 +0200
> >
> > +++ b/include/linux/kexec.h
> > @@ -187,6 +187,8 @@ extern u32 vmcoreinfo_note[VMCOREINFO_NO
> >  extern size_t vmcoreinfo_size;
> >  extern size_t vmcoreinfo_max_size;
> >  
> > +int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
> > +		unsigned long long *crash_size, unsigned long long *crash_base);
> 
> I still want to point out my consernes about `unsigned long long long'
> bloat.

What "concerns" (it's unsigned long long and not unsigned long long
long)? Is is common coding style in the Linux kernel to *not* use
unsigned long long? This type *is* used e.g. in
arch/i386/kernel/e820.c also for pysical memory values.

> #v+
> olecom@flower:/tmp$ grep '@offset' <extended-crashkernel-cmdline.mbox
>     crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
> -       /* crashkernel=size@offset specifies the size to reserve for a crash
> +While the "crashkernel=size[@offset]" syntax is sufficient for most
> +    crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
> +       crashkernel=range1:size1[,range2:size2,...][@offset]
> olecom@flower:/tmp$ grep '@base' <extended-crashkernel-cmdline.mbox
> + *     crashkernel=size[@base]
> olecom@flower:/tmp$ grep '@<base' <extended-crashkernel-cmdline.mbox
> + *   crashkernel=<ramsize-range>:<size>[,...][@<base>]
> olecom@flower:/tmp$ grep '@<offset' <extended-crashkernel-cmdline.mbox
> olecom@flower:/tmp$
> #v-

The patch below fixes this.

> > + *
> > + * The function returns 0 on success and -EINVAL on failure.
> > + */
> > +static int __init parse_crashkernel_mem(char 			*cmdline,
> > +					unsigned long long	system_ram,
> > +					unsigned long long	*crash_size,
> > +					unsigned long long	*crash_base)
> > +{
> > +	char *cur = cmdline;
> > +
> > +	/* for each entry of the comma-separated list */
> > +	do {
> > +		unsigned long long start = 0, end = ULLONG_MAX;
> > +		unsigned long long size = -1;
> 
> memparse(), as a wrapper for somple_strtoll(), always have a return value
> (zero by default).
> <http://article.gmane.org/gmane.linux.kernel/583426>

Next reply (because of a different patch).


---

Only use 'offset' and not 'base' for the address where the reserved area
starts.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 kernel/kexec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1157,7 +1157,7 @@ module_init(crash_notes_memory_init)
 /*
  * This function parses command lines in the format
  *
- *   crashkernel=<ramsize-range>:<size>[,...][@<base>]
+ *   crashkernel=ramsize-range:size[,...][@offset]
  *
  * The function returns 0 on success and -EINVAL on failure.
  */
@@ -1222,7 +1222,7 @@ static int __init parse_crashkernel_mem(
 /*
  * That function parses "simple" (old) crashkernel command lines like
  *
- * 	crashkernel=size[@base]
+ * 	crashkernel=size[@offset]
  *
  * It returns 0 on success and -EINVAL on failure.
  */
