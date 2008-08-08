Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbYHHTwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbYHHTwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYHHTwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:52:12 -0400
Received: from gw.goop.org ([64.81.55.164]:43915 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbYHHTwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:52:11 -0400
Message-ID: <489CA3DA.1090400@goop.org>
Date: Fri, 08 Aug 2008 12:51:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Use of barriers in pvclock ABI
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Xen, we guarantee that the pv clock record will only ever be updated 
by the current cpu, so there will never be any cross-cpu barrier or 
synchronization issues to consider, nor any chance a vcpu will see its 
own clock record in a partially updated state.

I notice the current kvm implementation is the same.

However, the pvclock_clocksource_read() implementation is 
over-engineered, because it checks for an odd version and uses very 
strong rmb() barriers (which generates either an "lfence" or "lock add 
$0, (%esp)").

If we're happy to guarantee as an ABI issue that the record will never 
be updated cross-cpu, then we can make the barriers simply barrier() and 
just check for (src->version != dst->version).

Is that OK with you, or do you want to leave open the possibility of 
doing cross-cpu time updates?

    J
