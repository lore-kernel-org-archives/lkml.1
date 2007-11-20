Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbXKTAio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbXKTAio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXKTAih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:38:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbXKTAig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:38:36 -0500
Date: Mon, 19 Nov 2007 16:38:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mgross@linux.intel.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH]intel-iommu-PMEN support
Message-Id: <20071119163802.92cf1ac8.akpm@linux-foundation.org>
In-Reply-To: <20071116223957.GA26796@linux.intel.com>
References: <20071116223957.GA26796@linux.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 14:39:57 -0800
mark gross <mgross@linux.intel.com> wrote:

> -#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings) - 1
> +#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)

hm.  The logic in there looks screwy.


static char *fault_reason_strings[] =
{
	"Software",
	"Present bit in root entry is clear",
	"Present bit in context entry is clear",
	"Invalid context entry",
	"Access beyond MGAW",
	"PTE Write access is not set",
	"PTE Read access is not set",
	"Next page table ptr is invalid",
	"Root table address invalid",
	"Context table ptr is invalid",
	"non-zero reserved fields in RTP",
	"non-zero reserved fields in CTP",
	"non-zero reserved fields in PTE",
	"Unknown"
};
#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)

char *dmar_get_fault_reason(u8 fault_reason)
{
	if (fault_reason >= MAX_FAULT_REASON_IDX)
		return fault_reason_strings[MAX_FAULT_REASON_IDX - 1];
	else
		return fault_reason_strings[fault_reason];
}


so all invalid fault_reasons will cause us to display "non-zero reserved
fields in PTE".

Why not just do

	if (fault_reason >= ARRAY_SIZE(fault_reason_strings))
		return "Unknown";
	return fault_reason_strings[fault_reason];

?

(might as well make fault_reason_strings[] const, too).
