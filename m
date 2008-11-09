Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYKIRp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYKIRp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 12:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbYKIRpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 12:45:50 -0500
Received: from lazybastard.de ([212.112.238.170]:59604 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbYKIRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 12:45:49 -0500
Date: Sun, 9 Nov 2008 18:45:10 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       open-osd development <osd-dev@open-osd.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/18 ver2] libosd: OSDv1 Headers
Message-ID: <20081109174509.GB5350@logfs.org>
References: <491073BB.4000900@panasas.com> <1225817046-5946-1-git-send-email-bharrosh@panasas.com> <4916F934.4090205@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4916F934.4090205@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 November 2008 16:52:36 +0200, Boaz Harrosh wrote:
> 
> +struct osdv1_cdb {
> +	struct osd_cdb_head h;
> +	u8 caps[OSDv1_CAP_LEN];
> +	struct osd_security_parameters sec_params;
> +} __packed;

__packed can result in slow code being generated.  But removing the
attribute can lead to bugs on other architectures.  F.e. the size of
the structure below is different for i386 and x86_64.

struct foo {
	u64 bar;
	u32 baz;
};

My personal solution is to use this little macro and then just follow
every structure defition with a size check.

#define SIZE_CHECK(type, size)					\
static inline void check_##type(void)				\
{								\
	BUILD_BUG_ON(sizeof(struct type) != (size));		\
}
...
struct foo {
	u64 bar;
	u32 baz;
};

SIZE_CHECK(foo, 12);

The above would not compile on x86_64 and clearly indicate a missing
__packed.  In other cases the attribute can be removed.

Jörn

-- 
Invincibility is in oneself, vulnerability is in the opponent.
-- Sun Tzu
