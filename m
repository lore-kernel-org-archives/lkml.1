Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004Ab0ANK5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0ANK5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439Ab0ANK5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:57:06 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41223
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0ANK5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:57:05 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: kernel list <linux-kernel@vger.kernel.org>
Subject: git 9c501935a3cd broke the strace build.
Date: Thu, 14 Jan 2010 04:57:00 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-17-generic; KDE/4.2.2; x86_64; ; )
Cc: Ben Hutchings <ben@decadent.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001140457.00696.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    net: Support inclusion of <linux/socket.h> before <sys/socket.h>
>   
>    The following user-space program fails to compile:
>    
>        #include <linux/socket.h>
>        #include <sys/socket.h>

Did it ever?  Isn't #including both sys/thingy and a linux/thingy in the same 
program considered bad form?

>        int main() { return 0; }
>    
>    The reason is that <linux/socket.h> tests __GLIBC__ to decide whether it
>    should define various structures and macros that are now defined for
>    user-space by <sys/socket.h>, but __GLIBC__ is not defined if no libc
>    headers have yet been included.

Specifically, one of the tests was !__GLIBC__, I.E. checking that we _haven't_ 
included any of glibc's headers yet, which is presumably how you broke the 
strace 4.5.18 ./configure test checking for the existence of the 
linux/netlink.h file.  (That test #includes stddef.h, linux/socket.h, and 
linux/netlink.h and nothing else.  Since stddef.h is a gcc header and not a 
glibc header, __GLIBC__ isn't defined for the test code and thus that used to 
work under 2.5.31.  Now under 2.6.32 it dies with:

  linux/netlink.h:35: error: expected specifier-qualifier-list before
  'sa_family_t'

And later on the strace build breaks because it doesn't #include 
linux/netlink.h when it needs to.  (Why yes, autoconf _is_ brittle and near-
useless, thanks for noticing.)

*shrug*  I can patch the strace ./configure to include bits/socket.h instead of 
linux/socket.h, but what I can't understand is why _you_ couldn't.  (What use 
case did this patch actually fix?  Would reversing the order of those two 
headers have helped?)

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds

