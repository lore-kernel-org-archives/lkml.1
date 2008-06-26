Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYFZQSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYFZQSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 12:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYFZQSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 12:18:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbYFZQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 12:18:30 -0400
Date: Thu, 26 Jun 2008 09:12:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Solofo.Ramangalahy@bull.net, linux-kernel@vger.kernel.org,
       matthltc@us.ibm.com, cmm@us.ibm.com, manfred@colorfullife.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH -mm 1/3] sysv ipc: increase msgmnb default value wrt.
 the number of cpus
Message-Id: <20080626091216.e45099da.akpm@linux-foundation.org>
In-Reply-To: <4863AC5E.1070305@bull.net>
References: <20080624093452.946878437@bull.net>
	<20080624093453.201071209@bull.net>
	<20080624143120.9bed4f18.akpm@linux-foundation.org>
	<4863AC5E.1070305@bull.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 16:49:02 +0200 Nadia Derbey <Nadia.Derbey@bull.net> wrote:

> >>+. If the value is positioned from user space to a negative value, then
> >>+  the computation is reenabled. E.g.
> >>+
> >>+  # echo -1 > /proc/sys/kernel/msgmnb
> >>+
> >>+See recompute_msgmnb() function in ipc/ directory for details.
> >>+The value of msgmnb is coupled with the value of msgmni.
> >>+
> > 
> > 
> > The magical positive-versus-negative number trick is a bit obscure, and
> > I don't think there's any precedent for it in the kernel ABI (which is
> > what this is).
> > 
> > Is there anything we can do to reduce the unusualness of this
> > interface?  Say, add a new /proc/sys/kernel/automatic-msgmnb which
> > contains the automatic scaling and leave /proc/sys/kernel/msgmnb
> > containing the manual scaling?  Or something like that?
> 
> Well, I don't know if I well understood your proposal: is it 1 value in 
> automatic-msgmnb and another one in msgmnb?
> I don't clearly see how this could work.
> 
> IMHO, we should keep /proc/sys/kernel/msgmnb as a way to externalize the 
> current tunable value (whether it is automatically recomputed or not).
> 
> Also keep the current strategy: as soon as a value is written into that 
> file, give up with the automatic recomputing.
> 
> And use the file you propose as a way to go back and forth between 
> automatic recomputing and manual setting.
> 
> So the process would be the following:
> 1) kernel boots in "automatic recomputing mode"
>     /proc/kernel/sys/msgmni contains whatever value has been computed
>     /proc/kernel/sys/automatic-msgmnb contains "ON"
> 
> 2) echo <val> > /proc/kernel/sys/msgmnb
>     . sets msg_ctlmnb to <val>
>     . de-activates automatic recomputing (i.e. if, say, a cpu disappears
>       it won't be recompiuted anymore)
>     . /proc/kernel/sys/automatic-msgmnb now contains "OFF"
> 
> Echoing "OFF" into /proc/kernel/sys/automatic-msgmnb would have the same 
> effect (except that msg_ctlmnb's value would stay blocked at its current 
> value)
> 
> 3) echo "ON" > /proc/kernel/sys/automatic-msgmnb
>     . recomputes msgmnb's value based on the current available resources
>     . re-activates automatic recomputing for msgmnb.
> 
> Of course, all this should be applied to msgmni too.
> And may be this automatic-xxx file should be located under sysfs?
>    --> create /sys/kernel/automatic directory and have 1 file per 
> tunable to be scalled (who knows, may be we are adding other ones in th 
> future?)
> 
> Now, may be this is what you actually proposed and I completely 
> misunderstod it?
> 

I don't know what I proposed, sorry ;)  I didn't think about it very hard.

But the positive-values-mean-one-thing/negative-values-mean-another-thing
trick is unusual and rather unpleasing.  I was hoping you guys could come up
with a cleaner interface.

