Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbXJ0KYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbXJ0KYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 06:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXJ0KYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 06:24:04 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:45990 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbXJ0KYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 06:24:03 -0400
Message-ID: <472311B8.5080408@cosmosbay.com>
Date: Sat, 27 Oct 2007 12:23:52 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Marc Lehmann <linux-kernel@tst.eu>
CC: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: epoll design problems with common fork/exec patterns
References: <20071027062236.GA12476@schmorp.de> <4722F575.8080204@cosmosbay.com> <20071027085125.GC12326@schmorp.de> <47230351.8040100@cosmosbay.com> <20071027093424.GA31329@schmorp.de>
In-Reply-To: <20071027093424.GA31329@schmorp.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 27 Oct 2007 12:24:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Lehmann a écrit :
> On Sat, Oct 27, 2007 at 11:22:25AM +0200, Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> If such a bug exists on your kernel, please fill a complete bug report, 
>> giving details.
> 
> As this behaviour is clearly documented in the epoll manpage, why do you
> think it is a bug? I think its fairly bad, but at least tis documented as
> the behaviour it should be:
> 
>     Q6     Will the close of an fd cause it to be removed from all epoll sets automatically?
>     A6     Yes.

Answer : epoll documentation cannot explain the full semantic of file 
descriptors, or difference between user side (file descriptors) and kernel 
side (files and fds)
Or should, since you had problems. But then, if the epoll documentation has to 
document the full Unix/Linux files semantic, nobody will read it.

The 'close' of a file is not close(fd) :)
But : the last close() so that underlying file refcount is 0

example 1)

fd = open("somefile", ...)
fd1 = dup(fd);
epoll_add_in_my_set(fd1);/* setup epoll work on fd1 */
{do_something;}
close(fd1); /* this is not the last close and will NOT close 'somefile' */
             /* It wont be removed from epoll sets NOW */


close(fd); /* oh yes, this one is the real 'file close', now we perform epoll 
cleanups */

epoll has to deal with files, but documentation is a User side documentation, 
so has to use 'file descriptors'. So everything that plays with the file 
descriptor table can make the thing complex to understand/document. 
(fork()/dup()/close()/exit()/exec()....)

example 2)

int pfd[2];
pipe(pfd);
epoll_add_in_my_set(pfd[0]);/* setup epoll work on pfd[0] for example */
pid = fork();
if (pid == 0) {


    close(pfd[0]); /* this is not the last close and will NOT close pipe */
	/* epoll has NO WAY to perform some cleanup at this stage */

    close(pfd[1]); /* this not the last close and will NOT close the pipe*/
    _exit(0);
    }
close(pfd[1]);
wait(NULL);
{do_something_epoll_related;}
close(pfd[0]); /* finally we close the pipe, and epoll can do its cleanup */

fork() is acting sort of dup() , as it increases all file refcounts.

You have problems about close()/dup()/fork()/... file descriptors semantic, 
which is handled by a layer independent from epoll stuff.


