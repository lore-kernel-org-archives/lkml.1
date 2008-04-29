Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYD2Spj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYD2Spj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760027AbYD2SpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:45:18 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:42161 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759706AbYD2SpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:45:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=THIXscQ5NWtxCAt7AX5qpDqY+JZuxUW057dEEZRcjsDNoMCcKxlsLDXoohQAEKQKgj4IzCoROPdpv8Ppkvs/0kGoTui7D/RxuG7KDC6Ss7EOTc3EAibPKHfmr6dByo8c6Gj1VkskXHyr8Y61Q4Fclau1Dwyz0R3n98IVMv6Dfzc=  ;
X-YMail-OSG: cUSnPC8VM1n_Ww3Tw7t_bxFzBa_73uRhmhIUm2oEdd368TJQ0s3FVDhe543QWa3d6URo9GhZ9vLfSoA28orOopPP0V9bmqBLgnGXRFqa_BgtzzEnA_XH4KE1qChBLIgAQsU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Tue, 29 Apr 2008 11:45:13 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <20080428195455.6e07cb8d.akpm@linux-foundation.org> <20080429034219.GA1413@kroah.com>
In-Reply-To: <20080429034219.GA1413@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291145.14172.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, Greg KH wrote:
> On Mon, Apr 28, 2008 at 07:54:55PM -0700, Andrew Morton wrote:
> > On Mon, 28 Apr 2008 16:28:13 -0700 David Brownell <david-b@pacbell.net> wrote:
> > 
> > > > If we had a strcmp() variant which treats a \n in the first arg as a \0
> > > > the above would become
> > > > 
> > > > 	if (sysfs_streq(buf, "high"))
> > > > 		status = gpio_direction_output(gpio, 1);
> > > > 	else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
> > > > 		status = gpio_direction_output(gpio, 0);
> > > > 	else if (sysfs_streq(buf, "in"))
> > > > 		status = gpio_direction_input(gpio);
> > > 
> > > That would indeed be better.  Maybe I should whip up a sysfs
> > > patch adding that, and have this depend on that patch.  (I've
> > > CC'd Greg in case he has comments on that...)
> > 
> > Yes, it would be a standalone patch.  The sort which generates oceans of
> > useful feedback ;) The sort which also generates hundreds of
> > use-new-toy-to-clean-up-old-code patches for me to merge :(
> 
> Heh, sounds good to me :)

Hard to say where should live, but lib/strings.c seemed fair.
See the appended patch.  I made it not care which string has
newline termination, since caring seems very error-prone.

- Dave

========= CUT HERE
Add a new sysfs_streq() string comparison function, which ignores
the trailing newlines found in sysfs inputs.  By example:

	sysfs_streq("a", "b")	==> false
	sysfs_streq("a", "a")	==> true
	sysfs_streq("a", "a\n")	==> true
	sysfs_streq("a\n", "a")	==> true

This is intended to simplify parsing of sysfs inputs, letting them
avoid the need to manually strip off newlines from inputs.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 include/linux/string.h |    2 ++
 lib/string.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

--- g26.orig/include/linux/string.h	2008-04-29 05:45:53.000000000 -0700
+++ g26/include/linux/string.h	2008-04-29 05:55:14.000000000 -0700
@@ -109,5 +109,7 @@ extern void *kmemdup(const void *src, si
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
 
+extern bool sysfs_streq(const char *s1, const char *s2);
+
 #endif
 #endif /* _LINUX_STRING_H_ */
--- g26.orig/lib/string.c	2008-04-29 05:15:52.000000000 -0700
+++ g26/lib/string.c	2008-04-29 05:55:32.000000000 -0700
@@ -493,6 +493,33 @@ char *strsep(char **s, const char *ct)
 EXPORT_SYMBOL(strsep);
 #endif
 
+/**
+ * sysfs_streq - return true if strings are equal, modulo trailing newline
+ * @s1: one string
+ * @s2: another string
+ *
+ * This routine returns true iff two strings are equal, treating both
+ * NUL and newline-then-NUL as equivalent string terminations.  It's
+ * geared for use with sysfs input strings, which generally terminate
+ * with newlines but are compared against values without newlines.
+ */
+bool sysfs_streq(const char *s1, const char *s2)
+{
+	while (*s1 && *s1 == *s2) {
+		s1++;
+		s2++;
+	}
+
+	if (*s1 == *s2)
+		return true;
+	if (!*s1 && *s2 == '\n' && !s2[1])
+		return true;
+	if (*s1 == '\n' && !s1[1] && !*s2)
+		return true;
+	return false;
+}
+EXPORT_SYMBOL(sysfs_streq);
+
 #ifndef __HAVE_ARCH_MEMSET
 /**
  * memset - Fill a region of memory with the given value
