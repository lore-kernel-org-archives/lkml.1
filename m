Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbYDAUOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbYDAUOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758498AbYDAUNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:13:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54711 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbYDAUNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:13:51 -0400
Date: Tue, 1 Apr 2008 22:13:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: David Newall <davidn@davidnewall.com>, "John T." <j.thomast@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
In-Reply-To: <47EE76BD.2000708@zytor.com>
Message-ID: <alpine.LNX.1.10.0804012200340.6604@fbirervta.pbzchgretzou.qr>
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr> <47ED8C13.5060509@zytor.com>
 <alpine.LNX.1.10.0803290143180.18418@fbirervta.pbzchgretzou.qr> <47EDE2A4.8080702@davidnewall.com> <47EE76BD.2000708@zytor.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-03-29 18:05, H. Peter Anvin wrote:
> David Newall wrote:
>>  Jan Engelhardt wrote:
>> >  What do you mean by self-terminating? There is no easy
>> >  synchronization like in UTF-8, given you are anywhere inside
>> >  a text stream, how do you know (a) you are already in an
>> >  escape sequence and (b) how to figure out the rebegin of
>> >  normal text.
>>
>>  It's not very useful being able to tell you are inside a escape sequence
>>  unless you see that sequence from the start.  You do need the complete
>>  sequence to make sense of it.
>
> I think what Jan is alluding to is the property of UTF-8 text that you can 
> start in the middle of a string and either skip an incomplete character or 
> find the beginning of it.  If you can search backwards, you can find the 
> beginning of an escape sequence, too; the "skip incomplete"  functionality is 
> missing, though, but as you say, isn't actually all that useful in real life 
> *for the applications which use these kinds of escape sequences.*

No backwards searching, just forwards.

In UTF-8 this is simple. You know you are in a character when the highest
two bits are 10, and you can skip bytes until the start of the next
character, whose highest bits are either 00 or 11.

With the VTxxx escape codes, this is hardly possible. Given a broken
code of ^[43m,

 	echo -e '\x1B[43m wonderful \x1B[0m' | cosmicrays | cat

 	3m wonderful ^[[0m

There is no way to check whether you are in the escape code. And there
is no way to find its end. If a heuristic were to be used (which is
certainly a possibility), you would end up killing text up until the
next ^[.

Hence the proposal of using definite start and end markers:

 	echo -e '\x1B43m\x1D wonderful \x1B0m\x1D' | cosmicrays | cat

 	3m^] wonderful ^[0m^]

Ok, finding out whether we are in an escape code is not as easy as with
UTF-8 (the latter of which looks at the current character only), but
still very viable.
Prerequisite to this simple model is that the user does not use an
overly long dumb escape sequence like ^[[43;43;43;43;43;43m, i.e.
that the end marker is in the buffer if we really are in an escape
sequence:

 	static bool in_an_escape_seq(const char *buf)
 	{
 		const char *e = strchr(buf, 0x1D);
 		return e != NULL && e < strchr(buf, 0x1B);
 	}

If so, skipping parts of a faulty write() is easy:

 	static const char *get_out_of_esc(const char *buf)
 	{
 		if (in_an_escape_seq(buf))
 			return strchr(buf, 0x1D) + 1;
 		else
 			return buf;
 	}


-- 
make boldconfig -- to boldly select what no one has selected before
