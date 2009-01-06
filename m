Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZAFWIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZAFWIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZAFWIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:08:13 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:53870 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZAFWIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:08:13 -0500
Date: Tue, 6 Jan 2009 23:09:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090106220950.GA23838@uranus.ravnborg.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LKDeQ-0002xz-7E@closure.thunk.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 10:15:26AM -0500, Theodore Ts'o wrote:
> The following commit, ad7a953c, "kbuild: strip generated symbols from
> *.ko" which was merged to the mainline last week (December 28th) has the
> unfortunate side effct of making ccache useless.  That's because all
> files are now built using a two step process.  First they are compiled
> to assembly via "gcc -S -o .tmp_foo.s" and then assembled via "gcc" in a
> separate step.  Unfortunately, ccache doesn't seem to be able to cache
> either the compilation or the assembly step (and it may not be worth it
> once the two steps are separated).

Hi Ted.

How about this simple patch.

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5d90030..3b9b8f5 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -208,7 +208,7 @@ cmd_modversions =							\
 		fi;							\
 	else								\
 		rm -f $(v_file);					\
-		$(CC) $(no_g_c_flags) -c -o $@ $(s_file);		\
+		$(CC) $(no_g_c_flags) -c -o $@ $< ;			\
 	fi;
 endif
 

It basically starts all over again with the C file if the
file did not export any symbols (typical case).

This I think should allow ccache to be functional again.

I do not propose this as a final suggestion - more so
that I'm sure I understand the problem.

	Sam
