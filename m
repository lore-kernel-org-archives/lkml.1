Return-Path: <linux-kernel-owner+w=401wt.eu-S934267AbXGTVKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267AbXGTVKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758944AbXGTVJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:09:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:16858 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932AbXGTVJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:09:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VoTEh99kUU46LGySNSztdWFIPycM2XyjCXlvLsHE1q5zEnvUrNABGZU4GinqLMVwL
	U6Mi5qacWgle401FnQhyw==
Message-ID: <6599ad830707201409s30badabage2518dad09f17ae4@mail.gmail.com>
Date: Fri, 20 Jul 2007 14:09:09 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm PATCH 4/8] Memory controller memory accounting (v3)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Containers" <containers@lists.osdl.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Eric W Biederman" <ebiederm@xmission.com>,
       "Linux MM Mailing List" <linux-mm@kvack.org>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <6599ad830707201403n6a364514y601996145fa3714c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720082352.20752.37209.sendpatchset@balbir-laptop>
	 <20070720082440.20752.67223.sendpatchset@balbir-laptop>
	 <6599ad830707201403n6a364514y601996145fa3714c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Paul Menage <menage@google.com> wrote:
> > +       mem = rcu_dereference(mm->mem_container);
> > +       /*
> > +        * For every charge from the container, increment reference
> > +        * count
> > +        */
> > +       css_get(&mem->css);
> > +       rcu_read_unlock();
>
> It's not clear to me that this is safe.
>

Sorry, didn't finish this thought.

Right after the rcu_dereference() the mm could be moved to another
container by some other process.

Since there's an rcu_synchronize() after the movement, and the
rcu_synchronize() caller holds container_mutex then I guess it's not
possible for a third process to delete the container during the RCU
section, since it won't be able to acquire the mutex until after the
RCU read section completes. So OK, it is safe, at least based on the
guarantees made by the current implementation.

Paul
