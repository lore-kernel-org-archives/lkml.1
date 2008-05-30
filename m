Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYE3XZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYE3XZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYE3XZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:25:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbYE3XZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:25:18 -0400
Date: Fri, 30 May 2008 16:25:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: casey@schaufler-ca.com, paul.moore@hp.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH BUGFIX -v2 -rc4] Smack: Respect 'unlabeled' netlabel
 mode
Message-Id: <20080530162500.1411f14d.akpm@linux-foundation.org>
In-Reply-To: <20080530235751.GA6888@ubuntu>
References: <20080530233603.GA2994@ubuntu>
	<20080530235751.GA6888@ubuntu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008 02:57:51 +0300
"Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> +		mutex_lock(&smack_ambient_lock);
> +		nlsp->domain = kstrdup(smack_net_ambient, GFP_ATOMIC);
> +		mutex_unlock(&smack_ambient_lock);

no no no no no.  And no.

GFP_ATOMIC is *unreliable*.  Using it in a "security" feature is a bug
- if it fails, the feature isn't secure any more.

Failing to check the kmalloc() return value might be a bug.

If we _need_ GFP_ATOMIC here then taking a mutex in a cannot-sleep
context is a bug.

The patch adds a kmalloc but doesn't add a kfree.  Is it leaky?

Finally, why is there a need to take a lock around a single store
instruction?
