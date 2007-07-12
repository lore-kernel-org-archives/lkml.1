Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbXGLIa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbXGLIa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXGLIaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:30:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:3773 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbXGLIaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:30:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,531,1175497200"; 
   d="scan'208";a="267351555"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <20070711111350.GI7091@elf.ucw.cz>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <20070711111350.GI7091@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Jul 2007 16:28:54 +0000
Message-Id: <1184257734.9346.76.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 12 Jul 2007 08:29:40.0096 (UTC) FILETIME=[CA285800:01C7C45E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 13:13 +0200, Pavel Machek wrote:
> Hi!
> 
> Looks interesting... but I was feeling strange dejavu reading
> this... and that's because you pasted the changelog twice :-).
> 

Sorry, I should have re-checked the mail before sending out.

> How fast can kexec boot secondary kernel?

I measure it on my IBM T42 with CONFIG_PRINTK_TIME=y. The boot-up time
is about 4.35s from kexec is issued to root mounted in kexec kernel.

I think it is possible to optimize. Maybe the kexec kernel can
be hibernate/resume by the normal kernel too. This way, a real
kexec/boot-up is only needed for the first time.

> > 2. Compile the kexec-tools with kdump and kjump patches added, the
> >    kdump patch can be found at:
> > 
> > http://lse.sourceforge.net/kdump/patches/kexec-tools-1.101-dkump10.patch
> 
> I got 404 error :-(.

Sorry, typo problem. The URL should be:
http://lse.sourceforge.net/kdump/patches/kexec-tools-1.101-kdump10.patch

> > 3. Boot compiled kernel, the reserved crash kernel memory region must
> >    be added to kernel command line as following:
> > 
> >    crashkernel=<XX>M@<XX>M
> > 
> >    Where, <XX> should be replaced by the real memory size and position.
> 
> How much memory do you suggest to reserve? 64M? 

I reserved 16M RAM. I think this is sufficient for a simple disk based
hibernation.

> > 7. In the kexec booted kernel, trigger the jumping back with following
> >    shell command.
> > 
> >    echo <a>:<b> > /sys/power/resume
> > 
> >    Where <a> and <b> is non-negative integer, at least one of them must
> >    be non-zero.
> 
> What does a and b mean?
> 

a and b has no meaning. They are only used to trigger the resume
process. This will be fixed in the future version.

> > +/* Adds the kexec_backup= command line parameter to command line. */
> > +static int cmdline_add_backup(char *cmdline, unsigned long addr)
> > +{
> > +	int cmdlen, len, align = 1024;
> > +	char str[30], *ptr;
> > +
> > +	/* Passing in kexec_backup=xxxK format. Saves space required in cmdline.
> > +	 * Ensure 1K alignment*/
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
> > +#if 0
> > +		printf("Command line after adding backup\n");
> > +		printf("%s\n", cmdline);
> > +#endif
> > +	return 0;
> > +}
> 
> printf()? ...and please remove out commented code.

This is patch against kexec-tools, which is a userspace tool. So printf
is used. The commented code is just as other cmdline_add_xxx functions
of kexec-tools. But it is useless, and should be removed.

Best Regards,
Huang Ying
