Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZJSF6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZJSF6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 01:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZJSF6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 01:58:49 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:60854 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZJSF6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 01:58:48 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 01:58:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A/XjhvQJM5q9oYeKpC/CSgAgZtS5jXoZcPqvG44MAQHJCMIvIIAXgbb5lIFNOdBXmn
         19zvz3BirC0MsnC9+newccrbZQXTJ3VjqydBnBtx0pu9kfHcxkiCSYT4EKUok/7TlEF9
         yYjghAP7djyGxzqSahV0BqgPLvjkxCs6ZC3nE=
MIME-Version: 1.0
In-Reply-To: <1255921080.839.2.camel@penberg-laptop>
References: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com>
	 <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com>
	 <20091019114339.4b67d947@infradead.org>
	 <1255921080.839.2.camel@penberg-laptop>
Date: Sun, 18 Oct 2009 22:52:01 -0700
Message-ID: <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com>
Subject: Re: nfs mount fail
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 7:58 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Mon, 2009-10-19 at 11:43 +0900, Arjan van de Ven wrote:
>> On Mon, 19 Oct 2009 05:35:20 +0300
>> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>
>> > >
>> > > [  278.734149] ------------[ cut here ]------------
>> > > [  278.739620] kernel BUG at mm/slub.c:2969!
>> >
>> > So this means that someone is passing a pointer to kfree() that did
>> > not come from kmalloc(). Which tree are you testing?
>>
>> > > [  278.770030] Pid: 2594, comm: rpciod/0 Not tainted
>> > > 2.6.32-rc5-tip-01483-ga166936-dirty #651
>>
>> some evil person decided to put the exact kernel tree/version in the
>> oops output ;-)
>
> Oh, right. Ingo, Yinghai says Linus' tree is fine so any ideas why this
> shows up in -tip? Also it seems we've had a similar bug before:
>
>  http://lkml.org/lkml/2009/4/2/698
>
> Hmmh?

yes. something miss merged again...

need change some lines.

---
 fs/nfs/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/nfs/super.c
===================================================================
--- linux-2.6.orig/fs/nfs/super.c
+++ linux-2.6/fs/nfs/super.c
@@ -1231,7 +1231,6 @@ static int nfs_parse_mount_options(char
 				goto out_nomem;
 			token = match_token(string,
 					    nfs_xprt_protocol_tokens, args);
-			kfree(string);

 			switch (token) {
 			case Opt_xprt_udp:
@@ -1254,6 +1253,7 @@ static int nfs_parse_mount_options(char
 			default:
 				dfprintk(MOUNT, "NFS:   unrecognized "
 						"transport protocol\n");
+				kfree(string);
 				return 0;
 			}
 			break;
@@ -1264,6 +1264,8 @@ static int nfs_parse_mount_options(char
 			token = match_token(string,
 					    nfs_xprt_protocol_tokens, args);

+			kfree(string);
+
 			switch (token) {
 			case Opt_xprt_udp:
 				mnt->mount_server.protocol = XPRT_TRANSPORT_UDP;
