Return-Path: <linux-kernel-owner+w=401wt.eu-S1760401AbZF2QVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbZF2QVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZF2QU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:20:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:43284 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZF2QU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:20:57 -0400
Message-ID: <4A48E9EB.9080803@kernel.org>
Date: Tue, 30 Jun 2009 01:20:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, npiggin@suse.de
Subject: Re: [PATCH 2/4] FUSE: make request_wait_answer() wait for ->end()
 completion
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-3-git-send-email-tj@kernel.org> <E1MJPJX-0001NB-SG@pomaz-ex.szeredi.hu>
In-Reply-To: <E1MJPJX-0001NB-SG@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 16:19:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

Miklos Szeredi wrote:
> On Thu, 18 Jun 2009, Tejun Heo wrote:
>> Previously, a request was marked FINISHED before ->end() is executed
>> and thus request_wait_answer() can return before it's done.  This
>> patch makes request_wait_answer() wait for ->end() to finish before
>> returning.
> 
> Why is this change needed?

Direct mmap implementation manages fds in the server process using the
end() callback.  After each command which needs to manipulate server
fds in some way, the end callback is responsible for doing it and
communicating what happened to the client side which is executing
fuse_file_direct_mmap(), so it needs to wait for end to complete
before proceeding.

>>  	spin_unlock(&fc->lock);
>> -	wake_up(&req->waitq);
>> -	if (end)
>> +
>> +	if (end) {
>>  		end(fc, req);
>> +		smp_wmb();
> 
> Why is this barrier needed?

To separate the changes end() made from setting FUSE_REQ_FINISHED.
The corresponding wait is in wait_answer_interruptible() and the
corresponding barrier is rmb() implied by spin_lock(&fc->lock) in that
function.  ie. the barrier makes sure that when
wait_event_interruptible() exits the waiting state because state
equals FUSE_REQ_FINISHED, the caller is guaranteed to see the changes
made by end().

Thanks.

-- 
tejun
