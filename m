Return-Path: <linux-kernel-owner+w=401wt.eu-S1767175AbXCILN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767175AbXCILN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767174AbXCILN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:13:29 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:33216 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767175AbXCILN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:13:28 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/7] revoke: add f_light flag for struct file
Date: Fri, 9 Mar 2007 12:13:35 +0100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
References: <Pine.LNX.4.64.0703091014110.32320@sbz-30.cs.Helsinki.FI> <200703091108.58371.dada1@cosmosbay.com> <84144f020703090243j6fd49b5eoa23f4cc12866725a@mail.gmail.com>
In-Reply-To: <84144f020703090243j6fd49b5eoa23f4cc12866725a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091213.35691.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 11:43, Pekka Enberg wrote:
> On 3/9/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> > Cannot we use a flag in 'struct files_struct', set to one when the task
> > is mono-thread (at task creation in fact), and set to 0 when it creates a
> > new thread  (or when someone remotely access to this "struct
> > files_struct" in /proc/pid/fd/... )
>
> How does that work? fget_light() has a built-in assumption that as
> long as you don't share files_struct, it's okay not to take an extra
> reference as current is only one doing close(2) and revoke(2) changes
> that. So it's not really about being single-threaded or not.

I just dropped one (silly ?) idea and expected you made the hard work :)

Then just drop the fget_light() 'optimisation' and always take a reference 
(atomic on f_count) regardless of single-thread or not. Instead of dirtying 
f_light, just do the straightforward thing and be with it.

(that is : fget_light() = fget() = no more keeping fput_needed everywhere, and 
convoluted things in some dark sides of the kernel.

It will save some conditional branches and complexity, and you dont need this 
f_light thing.

>
> On 3/9/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> > Also, the thing is racy.
>
> Aah, fget_light() indeed has a race window between fcheck_files() and
> set_f_light().

Yes, you see how hard it is to get this right.
