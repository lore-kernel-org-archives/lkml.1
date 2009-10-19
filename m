Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZJSHbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZJSHbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZJSHa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:30:58 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:63389 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbZJSHa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FHMg8+fE0+tCjzG/cu7UHcUaeNXeX9jOHsxLihRNskUSE/dR7oCK5rTsHbuAcT3EXk
         ykmO7S8ZcpFgG8Uj5XPBeTUGCCIQdiW0CgIIe1Dx0pCRyauI6BC9YKUBWm7rJc29JtfC
         rYNwicVibpZREeKJpZnNn1Yfzif98SSa78eKg=
MIME-Version: 1.0
In-Reply-To: <20091019070825.GA16493@elte.hu>
References: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com>
	 <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com>
	 <20091019114339.4b67d947@infradead.org>
	 <1255921080.839.2.camel@penberg-laptop>
	 <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com>
	 <1255933848.11116.2.camel@heimdal.trondhjem.org>
	 <20091019065433.GA29550@elte.hu>
	 <1255935518.18914.0.camel@penberg-laptop>
	 <20091019070825.GA16493@elte.hu>
Date: Mon, 19 Oct 2009 00:31:01 -0700
Message-ID: <86802c440910190031m33e116d3o90869de5212bb2e@mail.gmail.com>
Subject: Re: nfs mount fail
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 12:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
>> Hi Ingo,
>>
>> On Mon, 2009-10-19 at 08:54 +0200, Ingo Molnar wrote:
>> > * Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
>> >
>> > > > yes. something miss merged again...
>> > > >
>> > > > need change some lines.
>> > >
>> > > This doesn't match mainline either. To do so, the above kfree() has to
>> > > be at the end of the "Opt_xprt_rdma:" case...
>> >
>> > it's from a test patch in tip:out-of-tree:
>> >
>> >   d40bc6b: <not-for-merge> nfs: fix nfs_parse_mount_options() double kfree()
>> >
>> > (attached below)
>> >
>> > that fix is wrong apparently - is there a correct fix upstream perhaps?
>>
>> AFAICT, yes. See commit d508afb437daee7cf07da085b635c44a4ebf9b38 ("NFS:
>> Fix a double free in nfs_parse_mount_options()") from Trond.
>
> sigh. That was written 3 days after your and Yinghai's patch was sent -
> there's no Reported-by credit, there was no Cc: back to the original
> thread - plus there was a memory leak was left in there as well. Trond?
>
sth like this to fix possible mem leaking...

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index a2c18ac..90be551 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1253,6 +1253,7 @@ static int nfs_parse_mount_options(char *raw,
 			default:
 				dfprintk(MOUNT, "NFS:   unrecognized "
 						"transport protocol\n");
+				kfree(string);
 				return 0;
 			}
 			break;
