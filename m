Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYHaKPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYHaKPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 06:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbYHaKPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 06:15:07 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:56339 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbYHaKPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 06:15:05 -0400
Message-ID: <48BA6F25.8040102@dgreaves.com>
Date: Sun, 31 Aug 2008 11:15:01 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [Regression] Re: setlocalversion wasn't producing git labels for
 bisect
References: <48B9A2C7.3080001@dgreaves.com>
In-Reply-To: <48B9A2C7.3080001@dgreaves.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:

> Trying to do a bisect with git version 1.5.6.3 didn't work with the setlocalversion script
>
> Running
>   git name-rev --tags HEAD
> gives the output
>   HEAD tags/v2.6.27-rc4~44^2
>
> This isn't matched by setlocalversion regexp so it makes it harder to make deb-pkg/install/grub/reboot/remove
>
> Of course if this patch is accepted it is going to make life complicated when bisecting around it.
> Maybe git should behave as the man page suggests and have the ^X before the ~nnn? (maybe it has been fixed already)
>   http://www.kernel.org/pub/software/scm/git/docs/v1.5.6.5/git-name-rev.html
> shows an example:
>   33db5f4d9027a10e477ccf054b2c1ab94f74c85a tags/v0.99^0~940
OK, I apologise if I'm being dim.
I use git to get source for all my kernels on all my various machines. Rather than have them all pull from kernel.org I have a local mirror setup that also merges in the stable branches so I can get any tag without hitting the WAN.

When I do

cd /usr/src/linux-git/

git reset --hard v2.6.27-rc5

git bisect start

git bisect bad v2.6.27-rc4

git bisect good v2.6.27-rc3
zcat /proc/config.gz > .config

make oldconfig

make include/config/kernel.release

$ cat include/config/kernel.release
2.6.27-rc3

I think this should be a -git<nnnnn>

OK I have just done a fresh clone and tried it on that - it's nothing to do with my merged setup. I've also asked on irc and someone else had the problem too.

So now I think setlocalversion should be (at least)
+    if git name-rev --tags HEAD | grep -E '^HEAD[[:space:]]+(.*[0-9^~]*|undefined)$' > /dev/null; then

I'm cc'ing the git group since I suspect this is to do with branches or rebases or something arcane and it would be good to get the regexp right.
The git-rev-parse manpage talks about many other formats but it's not easy to see which are valid input and which are possible output.
I also wondered about using git rev-parse in the script but I'm not sure.
 [ -z `git tag -l \`git name-rev --name-only --tags HEAD\`` ]
sprang to mind but I'm still getting ^0 on the end of name-rev in 1.5.6.3 and of course older git versions won't work.


In any case I think bisecting using localversion is broken around this point... I'll get on it manually for the actual bug I've got :)

David


