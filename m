Return-Path: <linux-kernel-owner+w=401wt.eu-S932856AbYCSUXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbYCSUXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbYCSTj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:26 -0400
Received: from gw.goop.org ([64.81.55.164]:39425 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222AbYCSTir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:47 -0400
Message-ID: <47DFE75B.7080404@goop.org>
Date: Tue, 18 Mar 2008 09:01:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Christopher S. Aker" <caker@theshore.net>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org, xming <xmingske@gmail.com>
Subject: Re: [Xen-devel] Re: Xen paravirt frontend block hang
References: <4772AC8E.7010007@theshore.net> <47C712EF.1060703@goop.org>	<47C9F818.4020200@theshore.net> <47CAC931.1000107@goop.org> <47CACFBE.5010007@theshore.net>
In-Reply-To: <47CACFBE.5010007@theshore.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher S. Aker wrote:
> Jeremy Fitzhardinge wrote:
>> Are you running an SMP or UP domain?  I found I could get hangs very 
>> easily with UP (but I need confirm it isn't a result of some other 
>> very experimental patches).
>
> The hang occurs with both SMP and UP compiled pv_ops kernels.  SMP 
> kernels are still slightly responsive after the hang occurs, which 
> makes me think only one proc gets stuck at a time, not the entire kernel. 

The patch I posted yesterday - "xen: fix RMW when unmasking events" - 
should definitively fix the hanging-under-load bugs (I hope).  It 
problem came from returning to userspace with pending events, which 
would leave them hanging around on the vcpu unprocessed, and eventually 
everything would deadlock.  This was caused by using an unlocked 
read-modify-write operation on the event pending flag - which can be set 
by another (real) cpu - meaning that the pending event wasn't noticed 
until too late.  It would only be a problem on an SMP host.

The patch should back-apply to 2.6.24.

    J
