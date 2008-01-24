Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbYAXMeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbYAXMeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYAXMel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:34:41 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:40625
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbYAXMek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:34:40 -0500
Message-ID: <479885DC.8070100@qumranet.com>
Date: Thu, 24 Jan 2008 14:34:36 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@qumranet.com>
CC: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Izik Eidus <izike@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
References: <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com> <479716AD.5070708@qumranet.com> <20080123105246.GG26420@sgi.com> <Pine.LNX.4.64.0801231145210.13547@schroedinger.engr.sgi.com> <4798289B.1000007@qumranet.com> <20080124122623.GK7141@v2.random>
In-Reply-To: <20080124122623.GK7141@v2.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Thu, Jan 24, 2008 at 07:56:43AM +0200, Avi Kivity wrote:
>   
>> What I need is a list of (mm, va) that map the page.  kvm doesn't have 
>> access to that, export notifiers do.  It seems reasonable that export 
>> notifier do that rmap walk since they are part of core mm, not kvm.
>>     
>
> Yes. Like said in earlier email we could ignore the slowdown and
> duplicate the mm/rmap.c code inside kvm, but that looks a bad layering
> violation and it's unnecessary, dirty and suboptimal IMHO.
>
>   

Historical note: old kvm versions (like the what will eventually ship in 
2.6.24) have a page-based rmap (hooking the rmap list off 
page->private).  We changed that to an mm based rmap since page->private 
is not available when kvm maps general userspace memory.


>> Alternatively, kvm can change its internal rmap structure to be page based 
>> instead of (mm, hva) based.  The problem here is to size this thing, as we 
>> don't know in advance (when the kvm module is loaded) whether 0% or 100% 
>> (or some value in between) of system memory will be used for kvm.
>>     
>
> Another issue is that for things like the page sharing driver, it's
> more convenient to be able to know exactly which "sptes" belongs to a
> certain userland mapping, and only that userland mapping (not all
> others mappings of the physical page). So if the rmap becomes page
> based, it'd be nice to still be able to find the "mm" associated with
> that certain spte pointer to skip all sptes in the other "mm" during
> the invalidate.
>   

You also need the mm (or rather, the kvm structure, but they have a 1:1 
relationship) to be able to lock and maintain the shadow structures 
properly.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

