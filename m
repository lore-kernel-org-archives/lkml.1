Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYILPWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYILPWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYILPWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:22:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:61677 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYILPWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=NjQtnujqUsA9bbVNF2Gp5mNlWSvgkgDMjn9JI2kJXCAFQpwMRcjk3rjsIDB+631SnE
         d3snb1SJ+wWDFso/5sB/Npyd7sYiYtsdg9QsaDvDmMxRI3WYiQV8655zIlAcv6M10+9m
         kgruNuJjqoDvodCOhPzwlzV3K4nA90yDHzbyA=
Message-ID: <8bd0f97a0809120822n40c8f99k45bb91e670cca805@mail.gmail.com>
Date: Fri, 12 Sep 2008 11:22:21 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: tj@kernel.org
Subject: OSS sound core optionalization has __init/__exit mismatches
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this commit:
commit 1be95f401657e75984871c369d774d507e462939
Author: Tejun Heo <tj@kernel.org>
Date:   Thu Aug 28 16:42:51 2008 +0200
sound: make OSS sound core optional

results in this failure:
WARNING: vmlinux.o(.init.text+0xfbf0): Section mismatch in reference
from the function _init_soundcore() to the function
.exit.text:_cleanup_oss_soundcore()
The function __init _init_soundcore() references
a function __exit _cleanup_oss_soundcore().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
_cleanup_oss_soundcore() so it may be used outside an exit section.

and can easily be seen in sound/sound_core.c:
...
static int __init init_soundcore(void)
{
...
               cleanup_oss_soundcore();
...
}
...
static void __exit cleanup_oss_soundcore(void)
{
...
}
...
-mike
