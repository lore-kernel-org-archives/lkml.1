Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYJUASS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYJUASS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYJUASI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:18:08 -0400
Received: from poll.devit.com ([216.165.189.132]:57979 "EHLO mx0.devit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752542AbYJUASH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:18:07 -0400
X-Greylist: delayed 1510 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2008 20:18:07 EDT
Message-ID: <48FD19E9.8010807@flurg.com>
Date: Mon, 20 Oct 2008 18:53:13 -0500
From: "David M. Lloyd" <dmlloyd@flurg.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: david@lang.hm
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield() options
References: <alpine.DEB.1.10.0810201531010.21749@asgard.lang.hm> <20081020225318.GA10352@ghostprotocols.net> <alpine.DEB.1.10.0810201603510.21749@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0810201603510.21749@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2008 06:08 PM, david@lang.hm wrote:
> in the case I'm looking at there are two (or more) threads running with 
> one message queue in the center.
> 
> 'input threads' are grabbing the lock to add messages to the queue
> 
> 'output threads' are grabbing the lock to remove messages from the queue
> 
> the programmer is doing a pthread_yield() after each message is 
> processed in an attempt to help fairness (he initially added it in when 
> he started seeing starvation on single-core systems)
> 
> what should he be doing instead?

If you're seeing starvation, to me that's a good indicator that the 
granularity of queue items are too small... probably there'd be an overall 
benefit of grabbing more things at once from the queue.

To make a silly metaphor out of it - imagine you've got a bunch of office 
interns (threads) whose jobs are to fill out PQ9-12b forms.  An intern has 
to wait in line before they can get to the desk where the secretary is 
handing out the forms to be filled out, one by one.  An intern can fill out 
the form just as fast as the secretary hands it to them; if they do so, 
then one intern ends up doing all the work while the others just wait in line.

But in order to make everyone equally busy (by injecting sched_yield()) 
you're making the interns take the paper, walk back to their desk, fill it 
out, and then get back in line, which takes somewhat more time overall, 
despite making the interns look much busier.  A better solution would be to 
give each intern a big stack of forms so that they spend a greater 
proportion of time filling them out rather than waiting in line; perhaps if 
each intern is kept busy enough, the line will always be empty, which would 
be the best situation of all.

- DML
