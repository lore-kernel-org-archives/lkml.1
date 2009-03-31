Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZCaUof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZCaUof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZCaUoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:44:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37047 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbZCaUoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:44:20 -0400
Message-ID: <49D280C0.8010802@redhat.com>
Date: Tue, 31 Mar 2009 23:44:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 01/17] shm-signal: shared-memory signals
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <20090331184252.28333.70623.stgit@dev.haskins.net>
In-Reply-To: <20090331184252.28333.70623.stgit@dev.haskins.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> This interface provides a bidirectional shared-memory based signaling
> mechanism.  It can be used by any entities which desire efficient
> communication via shared memory.  The implementation details of the
> signaling are abstracted so that they may transcend a wide variety
> of locale boundaries (e.g. userspace/kernel, guest/host, etc).
>
> The shm_signal mechanism supports event masking as well as spurious
> event delivery mitigation.
> +
> +/*
> + *---------
> + * The following structures represent data that is shared across boundaries
> + * which may be quite disparate from one another (e.g. Windows vs Linux,
> + * 32 vs 64 bit, etc).  Therefore, care has been taken to make sure they
> + * present data in a manner that is independent of the environment.
> + *-----------
> + */
> +
> +#define SHM_SIGNAL_MAGIC 0x58fa39df
> +#define SHM_SIGNAL_VER   1
> +
> +struct shm_signal_irq {
> +	__u8                  enabled;
> +	__u8                  pending;
> +	__u8                  dirty;
> +};
>   

Some ABIs may choose to pad this, suggest explicit padding.

> +
> +enum shm_signal_locality {
> +	shm_locality_north,
> +	shm_locality_south,
> +};
> +
> +struct shm_signal_desc {
> +	__u32                 magic;
> +	__u32                 ver;
> +	struct shm_signal_irq irq[2];
> +};
>   

Similarly, this should be padded to 0 (mod 8).

Instead of versions, I prefer feature flags which can be independently 
enabled or disabled.

> +
> +/* --- END SHARED STRUCTURES --- */
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/interrupt.h>
> +
> +struct shm_signal_notifier {
> +	void (*signal)(struct shm_signal_notifier *);
> +};
>   

This means "->inject() has been called from the other side"?

(reading below I see this is so.  not used to reading well commented 
code... :)

> +
> +struct shm_signal;
> +
> +struct shm_signal_ops {
> +	int      (*inject)(struct shm_signal *s);
> +	void     (*fault)(struct shm_signal *s, const char *fmt, ...);
>   

Eww.  Must we involve strings and printf formats?

> +	void     (*release)(struct shm_signal *s);
> +};
> +
> +/*
> + * signaling protocol:
> + *
> + * each side of the shm_signal has an "irq" structure with the following
> + * fields:
> + *
> + *    - enabled: controlled by shm_signal_enable/disable() to mask/unmask
> + *               the notification locally
> + *    - dirty:   indicates if the shared-memory is dirty or clean.  This
> + *               is updated regardless of the enabled/pending state so that
> + *               the state is always accurately tracked.
> + *    - pending: indicates if a signal is pending to the remote locale.
> + *               This allows us to determine if a remote-notification is
> + *               already in flight to optimize spurious notifications away.
> + */
>   

When you overlay a ring on top of this, won't the ring indexes convey 
the same information as ->dirty?


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

