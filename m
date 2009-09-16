Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZIPOtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZIPOtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZIPOts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:49:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZIPOts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:49:48 -0400
Date: Wed, 16 Sep 2009 10:49:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tobias Oetiker <tobi@oetiker.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: io-controller: file system meta data operations
Message-ID: <20090916144946.GB5221@redhat.com>
References: <alpine.DEB.2.00.0909161445440.11232@sebohet.brgvxre.pu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0909161445440.11232@sebohet.brgvxre.pu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 02:58:52PM +0200, Tobias Oetiker wrote:
> Hi Vivek,
> 
> I am trying to optimize user-experience on a busy NFS server.
> 
> I think much could be achieved if the following was true.
> 
>   get a response to file system meta data operations (opendir,
>   readdir, stat, mkdir, unlink) within 200 ms even under heavy
>   read/write strain ...
> 
> In the course of my research I also tried the io-controller patches.
> 
> My test setup consists of several tar processes keeping a disk busy
> by packing and unpacking Linux kernels.
> 
> I was able to bring read and write bandwidth into balance by
> putting the reading and writing tars in to different cgroups.
> 
> Unfortunately this did not seem to help my goal since meta data
> operations do not seem to get treated differently from normal
> operations (or maybe even worse?)
> 
> Is there a way to get io-controller to help me with this?

Hi tobi,

Is it better with vanilla CFQ (without io controller). I see that CFQ
preempts the ongoing process if it receives a meta data request and that
way it provides faster response.

If yes, then similar thing should work for IO controller also. Wait there
is one issue though. If a file system request gets backlogged in a group
while a different group was being served, then preemption will not happen
and that's probably the reason you are not seeing better latencies.

I think there are two ways to handle this in IO controller.

- Put the meta data requesting processes at the front of the service tree
  in respective group. This will make sure that even if there are other
  sequential readers or heavy writers in the group, this request gets
  served quickly.

I will write a small patch for this. I think that should help you.

Thanks
Vivek
