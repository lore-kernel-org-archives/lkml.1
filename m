Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXHTQM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXHTQM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759601AbXHTQMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:12:14 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60085 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbXHTQMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:12:13 -0400
Date: Mon, 20 Aug 2007 18:12:11 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Refine FAT chmod checks
In-Reply-To: <87ps1i6xrh.fsf@duaron.myhome.or.jp>
Message-ID: <Pine.LNX.4.64.0708201803080.5333@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708201500490.30570@fbirervta.pbzchgretzou.qr>
 <87ps1i6xrh.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Aug 21 2007 00:17, OGAWA Hirofumi wrote:
>Jan Engelhardt <jengelh@computergmbh.de> writes:
>> when a vfat filesystem is mounted without the quiet option, chown fails, 
>> but chmod still succeeds. I think that is wrong.
>
>Could you explain why this is wrong more?

Suppose a vfat filesystem is mounted with umask=0 and [not-quiet].
Then all files will have mode 0777. Trying to change the owner will
fail, because fat does not know about owners or groups. chmod 0770,
on the other hand, will succeed, even though fat does not know about
the permission triplet [user/group/other].

So this patch changes fat's not-quiet behavior so that only UNIX
modes are accepted that can be mapped lossless between the fat disk
format and the local system. There is only one attribute, and that is
the readonly attribute, which is mapped to the UNIX write permission
bit(s). chmod 0555 is therefore valid (taking away the +w bits <=>
setting the readonly attribute). Since chmod 0775 and chmod 0755 is
an ambiguous case as to whether to set or clear the readonly bit,
these modes are also denied.

Does that help?



have a nice day,
	Jan
-- 
