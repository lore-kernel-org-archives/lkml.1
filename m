Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbZKRQUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbZKRQUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZKRQUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:20:14 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63165 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273AbZKRQUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:20:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P1pJ4hPbz1naroH/LqvAVqIP4ILr4Fx4prPJ6lGkjH8RC4HGTUvNvvULGVYtz0EUuP
         S90t5pEEJi0WDQtsYcj3bsulddPysAhsADMGPfAL4VpTt8eegxwZf4kj3EGuKhz5ToyC
         NzA0RAopM7adowROiKkj0iXbKOSL3SD2DS/G4=
MIME-Version: 1.0
In-Reply-To: <20091118153227.GA5796@redhat.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
	 <20091118153227.GA5796@redhat.com>
Date: Wed, 18 Nov 2009 17:20:12 +0100
Message-ID: <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Wed, Nov 18, 2009 at 4:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> o Currently we wait on sync-noidle service tree so that sync-noidle type of
>  workload does not get swamped by sync-idle or async type of workload. Don't
>  do this idling if there are no sync-idle or async type of queues in the group
>  and there are other groups to dispatch the requests from and user has decided
>  not to wait on slow groups to achieve better throughput. (group_idle=0).
>
>  This will make sure if some group is doing just random IO and does not
>  have sufficient IO to keep the disk busy, we will move onto other groups to
>  dispatch the requests from and utilize the storage better.
>
This group will be treated unfairly, if the other groups are doing
sequential I/O:
It will dispatch one request every 100ms (at best), and every 300ms at worst.
I can't see how this is any better than having a centralized service
tree for all sync-noidle queues.

Probably it is better to just say:
* if the user wants isolation (group_idle should be named
group_isolation), the no-idle queues go into the group no-idle tree,
and a proper idling is ensured
* if the user doesn't want isolation, but performance, then the
no-idle queues go into the root group no-idle tree, for which the end
of tree idle should be ensured. This won't affect the sync-idle
queues, for which group weighting will still work unaffected.

Corrado
