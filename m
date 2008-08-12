Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYHLAoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYHLAoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYHLAoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:44:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25534 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYHLAoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:44:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Gy5jg/lK/RrbW0St1R4lRaJY4y02C66gAKtnh09sKU08JoCwfHfbCtdakcsyhFKwv
	IzDuNBtt6ILLYxGzh17ew==
Message-ID: <6599ad830808111743l58322a46u84f7af3e21467b0b@mail.gmail.com>
Date: Mon, 11 Aug 2008 17:43:37 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 1/2] mm owner fix race between swap and exit
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
       xemul@openvz.org, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20080811173138.71f5bbe4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080811100719.26336.98302.sendpatchset@balbir-laptop>
	 <20080811100733.26336.31346.sendpatchset@balbir-laptop>
	 <20080811173138.71f5bbe4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 5:31 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> The fix is to notify the subsystem (via mm_owner_changed callback), if
>> no new owner is found by specifying the new task as NULL.
>
> This patch applies to mainline, 2.6.27-rc2 and even 2.6.26.
>
> Against which kernel/patch is it actually applicable?
>
> (If the answer was "all of the above" then please don't go embedding
> mainline bugfixes in the middle of a -mm-only patch series!)

The main thing this fixes is the memrlimit controller, which is only
in -mm. But there's also a dereference of mm->owner in memcontrol.c -
and I think that needs to be fixed to handle a possible NULL mm->owner
too, since in the case of a swapoff racing with the last user of an mm
exiting, I suspect that the swapoff code could try to pull in a page
that gets charged to the mm after its owner has been set to NULL.

Paul
