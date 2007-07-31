Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbXGaJZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbXGaJZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbXGaJZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:25:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:46243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782AbXGaJZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:25:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,202,1183359600"; 
   d="scan'208";a="111718814"
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20070731091004.GA2022@elf.ucw.cz>
References: <1184483593.1898.98.camel@caritas-dev.intel.com>
	 <20070731091004.GA2022@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 17:25:24 +0800
Message-Id: <1185873924.23149.86.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 31 Jul 2007 09:25:34.0714 (UTC) FILETIME=[BF83ADA0:01C7D354]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 11:10 +0200, Pavel Machek wrote:
> > Index: kexec-tools-1.101/kexec/arch/i386/crashdump-x86.c
> > ===================================================================
> > --- kexec-tools-1.101.orig/kexec/arch/i386/crashdump-x86.c	2007-07-08 23:00:25.000000000 +0800
> > +++ kexec-tools-1.101/kexec/arch/i386/crashdump-x86.c	2007-07-14 17:06:45.000000000 +0800
> > @@ -428,6 +428,29 @@
> >  	return 0;
> >  }
> >  
> > +/* Adds the kexec_backup= command line parameter to command line. */
> > +static int cmdline_add_backup(char *cmdline, unsigned long addr)
> > +{
> > +	int cmdlen, len, align = 1024;
> > +	char str[30], *ptr;
> > +
> > +	/* Passing in kexec_backup=xxxK format. Saves space required
> > +	 * in cmdline. Ensure 1K alignment*/
> > +	if (addr%align)
> > +		return -1;
> > +	addr = addr/align;
> > +	ptr = str;
> > +	strcpy(str, " kexec_backup=");
> > +	ptr += strlen(str);
> > +	ultoa(addr, ptr);
> > +	strcat(str, "K");
> > +	len = strlen(str);
> > +	cmdlen = strlen(cmdline) + len;
> > +	if (cmdlen > (COMMAND_LINE_SIZE - 1))
> > +		die("Command line overflow\n");
> > +	strcat(cmdline, str);
> > +	return 0;
> > +}
> 
> This part did not apply for me -- it seems crashdump related and I did
> not have that applied. Is it critical?

This is needed for kexec_jump to work properly. Which version of
kexec-tools do you use? This patch is against 1.101. The kdump patch
must be applied before this patch is applied.

> > Index: kexec-tools-1.101/kexec/kexec.c
> > ===================================================================
> > --- kexec-tools-1.101.orig/kexec/kexec.c	2007-07-14 16:57:26.000000000 +0800
> > +++ kexec-tools-1.101/kexec/kexec.c	2007-07-14 21:04:51.000000000 +0800
> > @@ -660,6 +660,17 @@
> >  	return -1;
> >  }
> >  
> > +/*
> > + *	Jump to the new kernel
> > + */
> > +static int my_jump(void)
> > +{
> > +	int result;
> > +
> > +	result = kexec_jump();
> > +	return result;
> > +}
> > +
> >  static void version(void)
> >  {
> >  	printf("kexec " VERSION " released " RELEASE_DATE "\n");
> > @@ -683,6 +694,7 @@
> >  		" -p, --load-panic     Load the new kernel for use on panic.\n"
> >  		" -u, --unload         Unload the current kexec target kernel.\n"
> >  		" -e, --exec           Execute a currently loaded kernel.\n"
> > +		" -j, --jump           Jump to a currently loaded kernel or jump back to the previous kernel.\n"
> >  		" -t, --type=TYPE      Specify the new kernel is of this type.\n"
> >  		"     --mem-min=<addr> Specify the lowest memory addres to load code into.\n"
> >  		"     --mem-max=<addr> Specify the highest memory addres to load code into.\n"
> > @@ -715,6 +727,7 @@
> >  {
> >  	int do_load = 1;
> >  	int do_exec = 0;
> > +	int do_jump = 0;
> >  	int do_shutdown = 1;
> >  	int do_sync = 1;
> >  	int do_ifdown = 0;
> > @@ -768,6 +781,14 @@
> >  			do_ifdown = 1;
> >  			do_exec = 1;
> >  			break;
> > +		case OPT_JUMP:
> > +			do_load = 0;
> > +			do_shutdown = 0;
> > +			do_sync = 1;
> > +			do_ifdown = 0;
> > +			do_exec = 0;
> > +			do_jump = 1;
> > +			break;
> >  		case OPT_TYPE:
> >  			type = optarg;
> >  			break;
> > @@ -833,6 +854,9 @@
> >  	if ((result == 0) && do_exec) {
> >  		result = my_exec();
> >  	}
> > +	if ((result == 0) && do_jump) {
> > +		result = my_jump();
> > +	}
> >  
> 
> Well, it may be nice to print something to the user he. kexec
> -j does nothing, and does not print error message in case something is
> wrong...

Yes. At least some message should be printed in case something is wrong.
I will fix it in the next version.

Best Regards,
Huang Ying
