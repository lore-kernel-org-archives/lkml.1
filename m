Return-Path: <linux-kernel-owner+w=401wt.eu-S1759688AbZE0HEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688AbZE0HEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757659AbZE0HEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:04:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38076 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbZE0HEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:04:00 -0400
Date: Wed, 27 May 2009 09:10:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 27/31] x86: MCE: Print header/footer only once for multiple MCEs
Message-ID: <20090527071035.GQ846@one.firstfloor.org>
References: <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com> <314f7c278aaaa41854bf4f0837a4ca6126160fc8.1243381848.git.ak@linux.intel.com> <ecbed09ba385129558d6341f6a48c64edaa164b4.1243381848.git.ak@linux.intel.com> <d9664a5ed1cdbfcd7888c7c7114619494114d4ab.1243381848.git.ak@linux.intel.com> <172ffa34ba8bc6a493e26f7e97fb7239f906b4e8.1243381848.git.ak@linux.intel.com> <e224e71ae8e2b578d4b4a0a079eea963445eaf91.1243381848.git.ak@linux.intel.com> <650bd32edc1814f1f792a07de9c5efebefc9c0b3.1243381848.git.ak@linux.intel.com> <b464e1eb871500ad8f4f6e5e5f6d394aec97e037.1243381848.git.ak@linux.intel.com> <2a7abea3d00cb5a1508d54b45bdb7a94fead46ee.1243381848.git.ak@linux.intel.com> <4A1CC228.9070404@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1CC228.9070404@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 01:31:36PM +0900, Hidetoshi Seto wrote:
> I suppose one possible benefit not to have it and do like this is that we
> can suppress printing header if there is no log to print.
> But on the other hand footer is always printed.

If there's a machine check exception there's a hardware error, 
so that message should be printed.

This can happen for example in the "external agent" case.

> >  #define PANIC_TIMEOUT 5 /* 5 seconds */
> 
> And if there is no log, do we still need to run mcelog?

Not manually if it runs correctly, but the kernel doesn't know that in 
advance. So in case someone picks it up from a console log
it might be still needed.

> >  	 * Make sure only one CPU runs in machine check panic
> > @@ -240,7 +246,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
> >  		struct mce *m = &mcelog.entry[i];
> >  		if ((m->status & MCI_STATUS_VAL) &&
> >  			!(m->status & MCI_STATUS_UC))
> > -			print_mce(m);
> > +			print_mce(m, &first);
> >  	}
> >  	/* Now print uncorrected but with the final one last */
> >  	for (i = 0; i < MCE_LOG_LEN; i++) {
> > @@ -248,12 +254,13 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
> >  		if (!(m->status & MCI_STATUS_VAL))
> >  			continue;
> >  		if (!final || memcmp(m, final, sizeof(struct mce)))
> > -			print_mce(m);
> > +			print_mce(m, &first);
> >  	}
> >  	if (final)
> > -		print_mce(final);
> > +		print_mce(final, &first);
> >  	if (cpu_missing)
> >  		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
> > +	print_mce_tail();
> >  	if (exp)
> >  		printk(KERN_EMERG "Machine check: %s\n", exp);
> >  	if (mce_panic_timeout < panic_timeout)
> 
> If mce_panic is only caller of mce_log_tail (and possible mce_log_head),
> it would be better to use printk directly than having such sub-function.

The coding standard recommends to avoid too long functions, so I split it out.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
