Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbZJGLf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbZJGLf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759056AbZJGLfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759006AbZJGLfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:35:54 -0400
Date: Wed, 7 Oct 2009 13:30:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signals: SEND_SIG_NOINFO should be considered as
	SI_FROMUSER()
Message-ID: <20091007113049.GA3421@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021918.GB21006@redhat.com> <20091006073100.4184128@magilla.sf.frob.com> <20091006133732.GB8628@redhat.com> <20091006175705.6547A22@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006175705.6547A22@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06, Roland McGrath wrote:
>
> > Perhaps, we should add the comment to explain that both SI_FROMUSER()
> > and si_fromuser() are only valid in the sending pathes.
>
> Yes.  Also now that you put them both in a sentence together, it is clear
> that it is insane to have two different things with those two names that
> differ only in capitalization.

I think this doesn't matter because we need more cleanups. As for naming
I agree, si_fromuser() sucks and I'd be happy to send the patch which
renames it (or re-send these 2 patches).

The problem is, both SI_FROMUSER() and SI_FROMKERNEL() must die imho.
In fact I think they should never exist.

	SI_FROMUSER(siptr)      ((siptr)->si_code <= 0)

note "<=", this means this helper is unuseable. What we need is another
macro/inline which checks "si_code < 0" (or >= 0 depending on naming),
this helper should be used by sys_sigqueueinfo/etc which can not not use
SI_FROMXXX() because SI_USER is rightly forbidden. __send_signal() can
use the new helper too.

Other cleanups which imho makes sense:

	- rename SEND_SIG_XXX

	- redefine them to make sure SEND_SIG_NOINFO != NULL

Oleg.

