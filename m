Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYJ3N1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYJ3N1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 09:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYJ3N0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 09:26:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:43056 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbYJ3N0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=GvD1xTNPj0TngkWHKOPmh7uXyZ8bdaDs7slPQqjzCAWXSEqNBoOS2V34Wy6Zr8bwuG
         8v7Hh3SHVRrVHjW9VW+VoIMf4sxDXhlJOVHeIencW4elYyZaro04eMuPsdzmEsxCI9KH
         bsvSTIWmFXMdCwq9idM0cWrSff1E4NlUofY/M=
Message-ID: <cfd18e0f0810300626k21a10b22y9f8ead75c02f7782@mail.gmail.com>
Date: Thu, 30 Oct 2008 08:26:50 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: Valdis.Kletnieks@vt.edu
Subject: Re: parent process behaviour to signal after vfork()
Cc: "Halesh S" <halesh.s@india.com>, linux-kernel@vger.kernel.org
In-Reply-To: <cfd18e0f0810300624g7948b2efqe979278413d746b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <loom.20081028T062822-852@post.gmane.org>
	 <517f3f820810290617m49b5deccu5d639cd0d3c94592@mail.gmail.com>
	 <53383.1225345110@turing-police.cc.vt.edu>
	 <cfd18e0f0810300624g7948b2efqe979278413d746b8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops -- forgot the patch.  Here it is:

--- a/man2/vfork.2
+++ b/man2/vfork.2
@@ -80,13 +80,15 @@ where a child will be created which then
immediately issues an
 .BR vfork ()
 differs from
 .BR fork (2)
-in that the parent is suspended until the child makes a call to
-.BR execve (2)
-or
-.BR _exit (2).
-The child shares all memory with its parent, including the stack, until
-.BR execve (2)
-is issued by the child.
+in that the parent is suspended until the child terminates
+(either normally,
+by calling
+.BR exit (2),
+or abnormally, after delivery of a fatal signal),
+or it makes a call to
+.BR execve (2).
+Until that point, the child shares all memory with its parent,
+including the stack.
 The child must not return from the current function or call
 .BR exit (3),
 but may call
@@ -95,9 +97,8 @@ but may call
 Signal handlers are inherited, but not shared.
 Signals to the parent
 arrive after the child releases the parent's memory
-(i.e., after the child calls
-.BR _exit (2)
-or
+(i.e., after the child terminates
+or calls
 .BR execve (2)).
 .SS "Historic Description"
 Under Linux,
@@ -135,11 +136,9 @@ The requirements put on
 by the standards are weaker than those put on
 .BR fork (2),
 so an implementation where the two are synonymous is compliant.
-In particular, the programmer cannot
-rely on the parent remaining blocked until a call of
-.BR execve (2)
-or
-.BR _exit (2)
+In particular, the programmer cannot rely on the parent
+remaining blocked until the child either terminates or calls
+.BR execve (2),
 and cannot rely on any specific behavior with respect to shared memory.
 .\" In AIXv3.1 vfork is equivalent to fork.
 .SH NOTES
