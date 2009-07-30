Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbZG3C5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbZG3C5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 22:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZG3C5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 22:57:41 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41475 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZG3C5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 22:57:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=qyBGjPt0skVpfHCghAbqPC7w/aFHxjSxvqS6eht2Co4W+HzAvaQzZun5Ks2eN8LeB
	dhLBjD8jQWpOUl3anCsVA==
MIME-Version: 1.0
In-Reply-To: <20090730020922.GD7326@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
	 <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com>
	 <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com>
	 <20090729114322.GA9335@localhost>
	 <33307c790907291719r2caf7914xb543877464ba6fc2@mail.gmail.com>
	 <33307c790907291828x6906e874l4d75e695116aa874@mail.gmail.com>
	 <20090730020922.GD7326@localhost>
Date: Wed, 29 Jul 2009 19:57:35 -0700
Message-ID: <33307c790907291957n35c55afehfe809c6583b10a76@mail.gmail.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Martin Bligh <mbligh@google.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       Michael Davidson <md@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On closer looks I found this line:
>
>                if (inode_dirtied_after(inode, start))
>                        break;

Ah, OK.

> In this case "list_empty(&sb->s_io)" is not a good criteria:
> here we are breaking away for some other reasons, and shall
> not touch wbc.more_io.
>
> So let's stick with the current code?

Well, I see two problems. One is that we set more_io based on
whether s_more_io is empty or not before we finish the loop.
I can't see how this can be correct, especially as there can be
other concurrent writers. So somehow we need to check when
we exit the loop, not during it.

The other is that we're saying we are setting more_io when
nr_to_write is <=0 ... but we only really check it when
nr_to_write is > 0 ... I can't see how this can be useful?
I'll admit there is one corner case when page_skipped it set
from one of the branches, but I am really not sure what the
intended logic is here, given the above?

In the case where we hit the inode_dirtied_after break
condition, is it bad to set more_io ? There is more to do
on that inode after all. Is there a definition somewhere for
exactly what the more_io flag means?

M.
