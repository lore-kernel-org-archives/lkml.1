Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZLUCAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZLUCAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 21:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbZLUCAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 21:00:09 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:39779 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbZLUCAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 21:00:08 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
References: <20091221220.243954235@firstfloor.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 20 Dec 2009 17:59:59 -0800
In-Reply-To: <20091221220.243954235@firstfloor.org> (Andi Kleen's message of "Mon\, 21 Dec 2009 02\:20\:21 +0100 \(CET\)")
Message-ID: <m1eimpm6hs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] [0/11] SYSCTL: Use RCU to avoid races with string sysctls
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> With BKL-less sysctls most of the writable string sysctls are racy. There
> is no locking on the reader side, so a reader could see an inconsistent
> string or worse miss the terminating null and walk of beyond it.

The walk will only extend up to the maximum length of the string.
So the worst case really is inconsistent data.

This is an unfortunate corner case.  This is not a regression as this
has been the way things have worked for years.  So probably 2.6.34
material.

> This patch kit adds a new "rcu string" variant to avoid these 
> problems and convers the racy users. One the writer side the strings are 
> always copied to new memory and the readers use rcu_read_lock()
> to get a stable view. For readers who access the string over
> sleeps the reader copies the string. 

I will have to look more after the holidays.  This rcu_string looks like
it introduces allocations on paths that did not use them before, which
has me wondering a bit.

Eric
