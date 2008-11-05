Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYKERfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYKERfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYKERfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:35:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57770 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYKERfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:35:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
	<1225810364-8990-9-git-send-email-ehabkost@redhat.com>
Date: Wed, 05 Nov 2008 09:33:06 -0800
In-Reply-To: <1225810364-8990-9-git-send-email-ehabkost@redhat.com> (Eduardo
	Habkost's message of "Tue, 4 Nov 2008 12:52:36 -0200")
Message-ID: <m1bpwu3wod.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eduardo Habkost <ehabkost@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1436]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 08/16] x86: Emergency virtualization disable function
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> +int set_virt_disable_func(void (*fn)(void))
> +{
> +	int r = 0;
> +
> +	spin_lock(&virt_disable_lock);
> +	if (!virt_disable_fn)
> +		rcu_assign_pointer(virt_disable_fn, fn);
> +	else
> +		r = -EEXIST;
> +	spin_unlock(&virt_disable_lock);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(set_virt_disable_func);

EXPORT_SYMBOL_GPL?

> +EXPORT_SYMBOL(clear_virt_disable_func);
EXPORT_SYMBOL_GPL?

We are talking a core internal api that should not even
be exported if KVM is compiled into the kernel.

I have had to tell people NO too many times by that
wanted to shove code on the kexec on panic path that
had no business there.  I do not want to give
the least little impression that this is an ok hook
for the to use.  The very specific name helps in
that regard thank you for that.  Having the symbol
exported GPL would help even more.

Overall I think the code is just barely ok.

I don't like the fact that to run 2-3 instructions per cpu we are two
function pointers deep.  It feels like we have an excess of
abstraction here on the kvm side.

Is it possible to have the individual kvm modules call
set_virt_disable_func and clear_virt_disable_func?  Instead
of going through the x86_kvm_ops?

It really feels like we have an excess of abstraction here.

Eric
