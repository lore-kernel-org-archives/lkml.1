Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYEDD6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYEDD6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 23:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYEDD6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 23:58:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54562 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbYEDD6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 23:58:08 -0400
Message-ID: <481D344C.9080904@tabi.org>
Date: Sat, 03 May 2008 22:58:04 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: mconf.c and bindtextdomain() -- warnings while cross-compiling on
 OS X
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm cross-compiling the kernel on an OS X system, and when I run "make 
menuconfig", I get this warning:

   HOSTCC  scripts/kconfig/mconf.o
scripts/kconfig/mconf.c: In function ‘main’:
scripts/kconfig/mconf.c:871: warning: statement with no effect
scripts/kconfig/mconf.c:872: warning: statement with no effect

Here is the code in question:

int main(int ac, char **av)
{
	int saved_x, saved_y;
	char *mode;
	int res;

	setlocale(LC_ALL, "");
	bindtextdomain(PACKAGE, LOCALEDIR);  <--- line 871
	textdomain(PACKAGE);

I believe the warnings are from this code in lkc.h:

#ifndef KBUILD_NO_NLS
# include <libintl.h>
#else
# define gettext(Msgid) ((const char *) (Msgid))
# define textdomain(Domainname) ((const char *) (Domainname))
# define bindtextdomain(Domainname, Dirname) ((const char *) (Dirname))
#endif

Can someone explain to me why this macros are defined in this way? Every 
place where textdomain() and bindtext() are used, they are used like this:

	bindtextdomain(PACKAGE, LOCALEDIR);
	textdomain(PACKAGE);

In other words, the return value from these macros is never used, so the 
warning is inevitable.

I think the code in lkc.h should be changed to:

# define textdomain(Domainname) do {} while(0)
# define bindtextdomain(Domainname, Dirname) do {} while(0)

I can't say for certain whether this is a good idea, though, because I'm 
not at all familiar with this code.
