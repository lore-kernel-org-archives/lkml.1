Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZCMH5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZCMH5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZCMH4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:56:53 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:17087 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZCMH4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:56:52 -0400
Message-Id: <49BA1FFC.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 13 Mar 2009 07:57:32 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Yinghai Lu" <yinghai@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix e820_update_range()
References: <49B914B6.76E4.0078.0@novell.com>
 <tip-82034d6f59b4772f4233bbb61c670290803a9960@git.kernel.org>
 <49B9E286.502@kernel.org>
In-Reply-To: <49B9E286.502@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Yinghai Lu <yinghai@kernel.org> 13.03.09 05:35 >>>
>
>Impact: fix left range size on head.
>
>| commit 5c0e6f035df983210e4d22213aed624ced502d3d
>|    x86: fix code paths used by update_mptable
>|    Impact: fix crashes under Xen due to unrobust e820 code
>fix one bug about e820 referring, but introduce other bug
>
>need update size for left range at first in case it is header.
>
>also add __e820_add_region take more parameter.
>
>Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>...
>+		/*
>+		 * left range could be head or tail, so need to update
>+		 * size at first.
>+		 */
>+		ei->size -= final_end - final_start;
> 		if (ei->addr < final_start)
> 			continue;
> 		ei->addr = final_end;
>-		ei->size -= final_end - final_start;

The change of mine here was done on purpose, since I had observed that
in this particular case (when the changed region starts later and ends earlier
than the original region) e820_add_region() would in any case create an
overlapping entry (which later gets cleaned up by sanitize_e820_map()).
That cleanup in sanitize_e820_map(), however, already implies reducing
the size of the enclosing region, and hence the original code (and the code
you try to restore now) effectively shrinks the original region twice.

Consequently, the only alternative to the code as resulting from my
patch appears to be to avoid the generation of overlapping entries in
the first place, but that would clearly make e820_update_range_map()
more complex.

Jan

