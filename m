Return-Path: <linux-kernel-owner+w=401wt.eu-S934157AbZJGIMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbZJGIMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933515AbZJGIMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:12:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933931AbZJGIMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:12:34 -0400
Message-ID: <4ACC4D46.1090805@redhat.com>
Date: Wed, 07 Oct 2009 10:11:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external	interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com> <4ACB0F3C.1000705@redhat.com> <4ACB46AD.8010405@gmail.com> <4ACB528D.6030408@gmail.com> <4ACB6F0E.4000407@redhat.com> <4ACB7794.5040308@gmail.com> <4ACB77C8.9060007@gmail.com> <4ACB9D24.2060105@gmail.com>
In-Reply-To: <4ACB9D24.2060105@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 09:40 PM, Gregory Haskins wrote:
> Thinking about this some more over lunch, I think we (Avi and I) might
> both be wrong (and David is right).  Avi is right that we don't need
> rmb() or barrier() for the reasons already stated, but I think David is
> right that we need an smp_mb() to ensure the cpu doesn't do the
> reordering.  Otherwise a different cpu could invalidate the memory if it
> reuses the freed memory in the meantime, iiuc.  IOW: its not a compiler
> issue but a cpu issue.
>
> Or am I still confused?
>
>    

The sequence of operations is:

     v = p->v;
     f();
     // rmb() ?
     g(v);

You are worried that the compiler or cpu will fetch p->v after f() has 
executed?  The compiler may not, since it can't tell whether f() might 
change p->v.  If f() can cause another agent to write to p (by freeing 
it to a global list, for example), then it is its responsibility to 
issue the smp_rmb(), otherwise no calculation that took place before f() 
and accessed p is safe.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

