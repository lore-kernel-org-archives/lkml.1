Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675Ab0ASQbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab0ASQbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 11:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146Ab0ASQbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 11:31:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab0ASQbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:31:06 -0500
Date: Tue, 19 Jan 2010 17:29:45 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Mike Frysinger <vapier@gentoo.org>
cc: Steven Rostedt <srostedt@redhat.com>,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig: dont hardcode path to lsmod
In-Reply-To: <520f0cf11001190822t6d3221bco20739d586608bfde@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001191723030.5999@localhost.localdomain>
References: <1263883920-17289-1-git-send-email-vapier@gentoo.org>  <20100119142545.GB3473@hack> <520f0cf11001190822t6d3221bco20739d586608bfde@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1225411871-1263918592=:5999"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1225411871-1263918592=:5999
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

 
>> On Tue, Jan 19, 2010 at 01:52:00AM -0500, Mike Frysinger wrote:
>> The lsmod utility has always been installed into /bin with the newer
>> module-init-tools package, so let lsmod be found via PATH instead of
>> hardcoding the old modutils /sbin path.
>>
> 
> Some distro doesn't set /sbin to PATH, so for me a better solution
> would be making PATH contain /sbin, and then use "lsmod".

How about the following solution then? (Warning, untested)
 
>From 6a98295f6dc260d13e1abb39210a2a832c9bdd1f Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Tue, 19 Jan 2010 17:10:48 +0100
Subject: [PATCH] kconfig: If lsmod is not in the /sbin, check the path
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Mike Frysinger reported that lsmod is installed in /bin on newer kernels
which causes a problem when we hardcode the path to /sbin

However, Américo Wang reports that some distros don't have /sbin in PATH, 
so you can't just let lsmod be found via PATH.

So, first check if lsmod is at /sbin/lsmod, and then check PATH if that fails.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 scripts/kconfig/streamline_config.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 0d80082..1803d2e 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -238,7 +238,8 @@ foreach my $makefile (@makefiles) {
 my %modules;
 
 # see what modules are loaded on this system
-open(LIN,"/sbin/lsmod|") || die "Cant lsmod";
+# If lsmod isn't in the sbin dir, check if it is in the path
+open(LIN,"/sbin/lsmod|") || open(LIN,"lsmod|") || die "Cant lsmod";
 while (<LIN>) {
 	next if (/^Module/);  # Skip the first line.
 	if (/^(\S+)/) {
-- 
1.6.0.6

--8323328-1225411871-1263918592=:5999--
