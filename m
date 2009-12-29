Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbZL2XoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbZL2XoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 18:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZL2Xn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 18:43:59 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:52081 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZL2Xn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 18:43:58 -0500
Subject: Question of resource_size() implementation
From: Felipe Balbi <me@felipebalbi.com>
Reply-To: me@felipebalbi.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 01:43:54 +0200
Message-ID: <1262130234.28789.112.camel@gandalf>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm wondering whether the +1 in resource_size() is actually necessary.
To illustrate the problem imagine we have two subsequent 4k memory areas
which should be passed to ioremap(). When passing those address spaces
to the drivers we will use struct resource and define something like:

#define MEM_AREA1_BASE	0x480ab000
#define MEM_AREA2_BASE	0x480ac000

struct resource my_device_resources = {
	{
		.start	= MEM_AREA1_BASE,
		.end	= MEM_AREA1_BASE + SZ_4K - 1,
		.flags	= IORESOURCE_MEM,
	},
	{
		.start	= MEM_AREA2_BASE,
		.end	= MEM_AREA2_BASE + SZ_4K - 1,
		.flags	= IORESOURCE_MEM,
	},
};

that -1 would cause us to pass the correct end for each area,
respectively 0x480abfff and 0x480acffff, right ?

But resource_size() is defined as:

static inline resource_size_t resource_size(const struct resource *res)
{
	return res->end - res->start + 1;
}

then we put +1 again and the end addresses would then become
respectively 0x480ac000 and 0x480ad0000. Wouldn't we then fail ioremap()
of the second area ? wouldn't it return -EBUSY ? Are we off-by-one
here ? Or is this all expected ?

I have to say, I didn't test this on real hw yet...

-- 
balbi

