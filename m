Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZJESoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZJESoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZJESoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:44:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbZJESox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:44:53 -0400
Date: Mon, 5 Oct 2009 20:39:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signals: SEND_SIG_NOINFO should be considered as
	SI_FROMUSER()
Message-ID: <20091005183947.GB943@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021918.GB21006@redhat.com> <20091005175855.GB30442@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005175855.GB30442@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05, Sukadev Bhattiprolu wrote:
>
> Oleg Nesterov [oleg@redhat.com] wrote:
> | >From __send_signal()'s pov they mean
> |
> | 	SEND_SIG_NOINFO		from user
>
> Just to complicate further, all 'SEND_SIG_NOINFO' signals are from user,
> but not all 'from user' signals are SEND_SIG_NOINFO.

Yes, SEND_SIG_NOINFO means: sent by kernel on behalf of some process.

>
> | 	SEND_SIG_PRIV		from kernel
>
> SEND_SIG_PRIV also means there is no real info, just that sender is
> privileged.

Well. Unlike SEND_SIG_FORCED, SEND_SIG_NOINFO/SEND_SIG_NOINFO ask
__send_signal() to allocate and queue "struct sigqueue". But
SEND_SIG_PRIV and SEND_SIG_NOINFO both mean the real info, jut
this info is filled by __send_signal().

> | 	SEND_SIG_FORCED		no info
>
> Are 'forced' signals considered 'from kernel' too ?

I think yes.

> | +static inline bool si_fromuser(const struct siginfo *info)
> | +{
> | +	return info == SEND_SIG_NOINFO ||
> | +		(!is_si_special(info) && SI_FROMUSER(info));
> | +}
> | +
>
> This change makes sense, but can we even drop the SEND_SIG_NOINFO
> altogether and simply check for NULL:
>
> 	return (!info || (is_si_special(info)) && SI_FROMUSER(info))

IOW, you suggest to use NULL instead of SEND_SIG_NOINFO.

Why?

If we use NULL as a "special" info, then SEND_SIG_FORCED semantics
makes more sense because __send_signal(SEND_SIG_FORCED) does not queue
info.

But I don't think we should use NULL. I think it is better to use the
symbolic names instead of NULL which is in fact the "harcoded constant".
But it would be nice to rename them.

Oleg.

