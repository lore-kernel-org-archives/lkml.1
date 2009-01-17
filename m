Return-Path: <linux-kernel-owner+w=401wt.eu-S1764609AbZAQVns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764609AbZAQVns (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZAQVni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:43:38 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:35409 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZAQVnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:43:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HkJuwb2vKy/kTVMSOjL7BBGRVvEIBGsho7pr2rgfEDktjlMV2JMNkLdPGYmUMRHDaN
         j0klfnD1bXcvudE90qPHTrMXwKJjfoTTWbmsxpMWfOwUoglDqCoxuJKwySAcDMzQpDUQ
         0ZTcOTqjA5U4gOP6QkQ+G1qHOMiaYaI6zKtBE=
Message-ID: <19f34abd0901171337p31b85393ifbc563a84e56d7e9@mail.gmail.com>
Date: Sat, 17 Jan 2009 22:37:30 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [slab corruption] BUG key_jar: Poison overwritten
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Michael LeMay" <mdlemay@epoch.ncsc.mil>,
       "James Morris" <jmorris@namei.org>,
       "Stephen Smalley" <sds@tycho.nsa.gov>, "Paul Moore" <paul.moore@hp.com>,
       "Eric Paris" <eparis@redhat.com>
In-Reply-To: <31147.1232224402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20090115181612.GA27762@elte.hu> <16916.1232172471@redhat.com>
	 <20090117082623.GB24905@elte.hu> <31147.1232224402@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0HLhtwM027888

On Sat, Jan 17, 2009 at 9:33 PM, David Howells <dhowells@redhat.com> wrote:> Ingo Molnar <mingo@elte.hu> wrote:>>> The problem was not reproducible - i tried the same config once more and>> it didnt produce the bug. (this system has no known hardware flukes)>> Having thought about it some more, we can't necessarily pin the blame on the> key management code.  I think it more likely due to the previous owner of the> page as it's the guard poisoning that got corrupted, not the allocated key> struct.  The problem is we don't know who that was.  I wonder if it's> practical to store a recent history of page allocs and releases in a circular> buffer.
This is what I think:
[   44.482064] INFO: 0xf5f320c0-0xf5f320c0. First byte 0x6a instead of 0x6b...[   44.482064]   Object 0xf5f320c0:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b6b 6b 6b 6b 6b jkkkkkkkkkkkkkkk
Only the first byte has been changed. It changed from 0x6b to 0x6a.Smells like a decrement. And yes, this particular cache allocates'struct key's, which has an 'atomic_t usage' as its first member. So arefcounting bug, most likely (key_put() was called too many times). Ora missing key_get() somewhere?
It also seems noteworthy that no other data has been changed since thelast key_put() (i.e. since the refcount hit zero).
[   44.482064] Bytes b4 0xf5f320b0:  7c 05 ff ff 5a 5a 5a 5a 5a 5a 5a5a 5a 5a 5a 5a |.ï¿½ï¿½ZZZZZZZZZZZZ
...I guess "bytes b4" means "bytes before"?

Vegard
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
