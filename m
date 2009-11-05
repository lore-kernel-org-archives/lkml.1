Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZKEMpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZKEMpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 07:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbZKEMp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 07:45:29 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46048 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbZKEMp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 07:45:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=f64nXF52xeV9uOwGUfq4Wst9pL9wVDHzo36akGcyLmku9vAQ5qiNNQ91UalKMe0Lz4
         3UvmdxxVmJYFJrJRIRCiu2CRcII4akaw2qCCCLVWT+yoyk+WCPfD8Bj/hvalzLUEfdyG
         ++FCNFNLXN669KPhnkNQ72nRi1FLKuGtfMdtE=
Message-ID: <4AF2C8E4.9020202@gmail.com>
Date: Thu, 05 Nov 2009 07:45:24 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Eric Dumazet <eric.dumazet@gmail.com>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder	Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com> <4AF0B0D2.4030905@gmail.com> <20091104214844.GA6714@linux.vnet.ibm.com> <4AF2C266.1010603@gmail.com>
In-Reply-To: <4AF2C266.1010603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson wrote:
> Yes.  Just shuffling the pointers without ever freeing anything.  So,
> there's nothing for call_rcu() to do, and nothing else to synchronize
> (only the pointers).  This assumes that after _unlock_ any CPU cache
> with an old pointer->expires will hit the _lock_ code, and that will
> update *both* ->expires and the other array elements concurrently?
> 
Reiterating, I've not found Documentation showing that this code works:

+	unsigned long jiffy = jiffies;
+
+	if (unlikely(time_after(jiffy, tcp_secret_generating->expires))) {
+		spin_lock_bh(&tcp_secret_locker);
+		if (!time_after(jiffy, tcp_secret_generating->expires)) {
+			/* refreshed by another */
+			spin_unlock_bh(&tcp_secret_locker);
+			memcpy(&xvp->cookie_bakery[0],
+			       &tcp_secret_generating->secrets[0],
+			       sizeof(tcp_secret_generating->secrets));
+		} else {

How is it ensured that an old tcp_secret_generating or an old ->expires,
followed by a spin_lock, has updated both?

And even when both are updated, then every word of the ->secrets array has
also been updated in the local cache?

Is this a property of spin_lock()?  Or spin_unlock()?
