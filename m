Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbYBNPX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbYBNPX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbYBNPXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:23:38 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33527 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbYBNPXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:23:37 -0500
Date: Thu, 14 Feb 2008 16:23:37 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
cc: Andi Kleen <andi@firstfloor.org>,
       Jasper Bryant-Greene <jasper@unix.geek.nz>,
       rzryyvzy <rzryyvzy@trashmail.net>, linux-kernel@vger.kernel.org
Subject: Re: Is there a "blackhole" /dev/null directory?
In-Reply-To: <20080214161942.55ce5089@dilbert.local>
Message-ID: <Pine.LNX.4.64.0802141620330.694@fbirervta.pbzchgretzou.qr>
References: <20080214093051.7240852AB0E31@trashmail.net>
 <1202981957.10928.17.camel@phobos.jasper.bg> <p73pruz27mk.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0802141553400.694@fbirervta.pbzchgretzou.qr>
 <20080214161942.55ce5089@dilbert.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 14 2008 16:19, Hans-Jürgen Koch wrote:
>> 
>> Q: What if a program attempts to mkdir /dev/nullmnt/foo to just
>>    create a file /dev/nullmnt/foo/barfile?
>> A: /dev/nullmnt/foo must continue to exist or be accepted for a while,
>>    or perhaps for eternity.
>
>Well, the problem seems to be that a "directory" is not just data but
>also contains metadata. While it's easy to write data to /dev/null, you
>cannot simply discard metadata associated with a directory. So, such a
>"/dev/null-directory" would have to remember metadata (at least all
>created filenames including subdirectories) in the same way as other
>filesystems do. Only file _content_ can be discarded.

Not even that. Suppose a userspace program (whose output you'd like
to discard) does:

int main(void)
{
	int fd = open("/nullmnt/foo.txt", O_WRONLY | O_CREAT | O_EXCL);

	/* write lots of nonsensical data that we don't need anyway */
	write(fd, "Hello Wor(l)d", 13);

	if (lseek(fd, 0, SEEK_SET) < 0) {
		/* should not happen */
		fprintf(stderr, "Huh, did we write to a pipe or cdev?\n");
		abort();
	}

	/* verify */
	char buf[13];
	read(fd, buf, 13);
	if (memcmp(buf, "Hello Wor(l)d", 13) != 0)
		fprintf(stderr, "Aïe, disk corruption!\n");
}

>To be honest, I still cannot see many sensible usecases for that...

I agree.
