Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbXJ0QA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbXJ0QA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbXJ0QAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:00:48 -0400
Received: from main.gmane.org ([80.91.229.2]:58532 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbXJ0QAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:00:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Check handling of kernel build output directory
Date: Sat, 27 Oct 2007 18:00:35 +0200
Message-ID: <472360A3.8020504@web.de>
References: <fft89p$rko$1@ger.gmane.org> <20071026190500.GA23480@uranus.ravnborg.org> <ffteuq$n3b$1@ger.gmane.org> <20071026194727.GA23871@uranus.ravnborg.org> <ffuh39$d7b$1@ger.gmane.org> <20071027072348.GA28566@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c7942.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <20071027072348.GA28566@uranus.ravnborg.org>
Cc: linux-kbuild@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Which files are not clean in my situation after the command "make mrproper" was executed
>> at the beginning?
> If you look at the top-level Makefile you will see:
> 
>         @echo '  Using $(srctree) as source for kernel'
>         $(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
>                 echo "  $(srctree) is not clean, please run 'make mrproper'";\
>                 echo "  in the '$(srctree)' directory.";\
>                 /bin/false; \
>         fi;
> 
> So you either a .config file or the config directory.

Well, I've thought about another viewpoint. The Makefile insists on the detail that no
configuration files are allowed in the source directory if an output directory was specified.
Original wording:
"...
# prepare3 is used to check if we are building in a separate output directory,
# and if so do:
# 1) Check that make has not been executed in the kernel src $(srctree)
..."

I seems now that my troubles came from the missing decision when to move or delete the
.config file from my source directory. So the following command sequence works for a
completely clean build. (It can be adjusted to support parallel configurations for
debug/release situations as usual.)

elfring@Sonne:~/Projekte/Linux/Kernel/2.6.23.1> unset KBUILD_OUTPUT && make mrproper && cp
-p /boot/config-2.6.23.1-0-adjusted .config && export
KBUILD_OUTPUT=~/Projekte/Linux/Kernel/obj/2.6.23.1/x86_64/adjusted && rm -rf
$KBUILD_OUTPUT/* && make silentoldconfig && rm .config && date && echo
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX && make -j4 && echo
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY && date
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  GEN     /home/elfring/Projekte/Linux/Kernel/obj/2.6.23.1/x86_64/adjusted/Makefile
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/lex.zconf.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/x86_64/Kconfig
Sa 27. Okt 17:37:38 CEST 2007
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  GEN     /home/elfring/Projekte/Linux/Kernel/obj/2.6.23.1/x86_64/adjusted/Makefile
[...]
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
Sa 27. Okt 17:55:09 CEST 2007

Regards,
Markus

