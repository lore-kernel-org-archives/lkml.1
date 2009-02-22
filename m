Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZBVUvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZBVUvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 15:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZBVUux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 15:50:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:22382 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZBVUuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 15:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=cc8gKRPtUQlHQb/hQo9Mhfve67NuAmQ1qgikGKszygFFAxJMf5PQCJ8H6W4HbBdsR1
         BHkaIikvmniyX71yts7MMNLcCtZwqe456QlW0EDRSJebHneP0fJsdv++p/e+dMEKHdTo
         wt0M+mmn66npzWiJ5Saeo02umgVK7LajVajiw=
Date: Sun, 22 Feb 2009 21:50:48 +0100 (CET)
From: Horst Reiterer <horst.reiterer@gmail.com>
X-X-Sender: horstreiterer@horst-reiterers-macbook-air.local
To: Steve French <smfrench@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] fs/cifs: send SMB_COM_FLUSH in cifs_fsync
In-Reply-To: <524f69650902201721l1c7f0d34p4708980a90d7fc8f@mail.gmail.com>
Message-ID: <alpine.OSX.2.00.0902222137080.7676@horst-reiterers-macbook-air.local>
References: <alpine.OSX.2.00.0902202138421.3998@horst-reiterers-macbook-air.local> <524f69650902201721l1c7f0d34p4708980a90d7fc8f@mail.gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 20 Feb 2009, Steve French wrote:
> I modified your patch slightly to not lose the writeback rc in one
> case, and to change camel case pTcon to tcon and remove one
> unnecessary local variable.

Thanks.

> If you have any performance numbers before and after (with e.g. dbench,
> iozone, bonnie etc. or perhaps something which calls fsync more often
> - that would be helpful in determining whether we need a mount option
> to optionally disable it - as the samba server does)

I tested the patch using a simple test driver that transfers data in 1MB
chunks and calls fsync after each chunk. The results are as follows:

  Test run            Throughput (MB/s)
                      1 client (MB/s) 10 clients 20 clients 40 clients
  cifs - vanilla                   64        116        117        111
  cifs - fsync.patch               54         90         95         95

As you can see, fsync does make a noticeable difference here. The problem
with benchmarks in this respect is that the difference solely depends on
the underlying device. In this scenario, the storage device featured a
battery-backed disk cache. Without it, the overhead would have been much
more significant.

In any case, it's probably a good idea to introduce a mount option. The
new behavior should be enabled by default though, to provide maximum data
consistency. While I can't think of a legitimate reason to disable fsync
if data consistency is a concern, an option might be useful in the
exceptional case where 1) data consistency is not a strict requirement and
2) SMB_COM_FLUSH cannot be ignored on the server side.

Thanks,

Horst.
