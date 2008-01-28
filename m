Return-Path: <linux-kernel-owner+w=401wt.eu-S1762060AbYA1V3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060AbYA1V3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYA1V3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:29:17 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51251 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbYA1V3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:29:15 -0500
Date: Mon, 28 Jan 2008 22:29:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: Preparing for merge window
Message-ID: <20080128212916.GB3842@uranus.ravnborg.org>
References: <20080124215813.GA4204@uranus.ravnborg.org> <20080124140422.409555b9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124140422.409555b9.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 02:04:22PM -0800, Randy Dunlap wrote:
> On Thu, 24 Jan 2008 22:58:13 +0100 Sam Ravnborg wrote:
> 
> > The following is the list of patches queued up for the merge window at the moment.
> > I have during the last week done several modpost changes to make section ismatch
> > warnings more reliable and I am happy with the modified modpost code now.
> 
> 
> Hi Sam,
> 
> Can you add (if not already done) a paragraph to kconfig-language.txt
> about the preference of using HAVE_feature in Kconfig files vs.
> other spellings of that?

I just added this and sent it off for pull. I wanted it included and
decided that review comments could be addressed in a follow-up patch.

Hopefully it is remotely understandable.

	Sam



>From ef8f5f34572a9adc9478840007d9fc4bcd7b6ad8 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 28 Jan 2008 21:49:46 +0100
Subject: [PATCH] kconfig: document use of HAVE_*

It has been discussed on lkml several times but we need
it documented as this is new stuff.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/kconfig-language.txt |   36 +++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index a43fcc6..649cb87 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -330,6 +330,42 @@ This is a collection of Kconfig tips, most of which aren't obvious at
 first glance and most of which have become idioms in several Kconfig
 files.
 
+Adding common features and make the usage configurable
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+It is a common idiom to implement a feature/functionality that are
+relevant for some architectures but not all.
+The recommended way to do so is to use a config variable named HAVE_*
+that is defined in a common Kconfig file and selected by the relevant
+architectures.
+An example is the generic IOMAP functionality.
+
+We would in lib/Kconfig see:
+
+# Generic IOMAP is used to ...
+config HAVE_GENERIC_IOMAP
+
+config GENERIC_IOMAP
+	depends on HAVE_GENERIC_IOMAP && FOO
+
+And in lib/Makefile we would see:
+obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
+
+For each architecture using the generic IOMAP functionality we would see:
+
+config X86
+	select ...
+	select HAVE_GENERIC_IOMAP
+	select ...
+
+Note: we use the existing config option and avoid creating a new
+config variable to select HAVE_GENERIC_IOMAP.
+
+Note: the use of the internal config variable HAVE_GENERIC_IOMAP, it is
+introduced to overcome the limitation of select which will force a
+config option to 'y' no matter the dependencies.
+The dependencies are moved to the symbol GENERIC_IOMAP and we avoid the
+situation where select forces a symbol equals to 'y'.
+
 Build as module only
 ~~~~~~~~~~~~~~~~~~~~
 To restrict a component build to module-only, qualify its config symbol
-- 
1.5.4.rc3.14.g44397

