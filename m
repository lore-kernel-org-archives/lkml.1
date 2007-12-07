Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbXLGMbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbXLGMbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 07:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXLGMbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 07:31:04 -0500
Received: from mail.op5.se ([193.201.96.20]:44721 "EHLO mail.op5.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbXLGMbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 07:31:03 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.399
Message-ID: <47593D00.9030003@op5.se>
Date: Fri, 07 Dec 2007 13:30:56 +0100
From: Andreas Ericsson <ae@op5.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Johannes Schindelin <Johannes.Schindelin@gmx.de>,
       Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: git guidance
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com> <200712070737.18519.a1426z@gawab.com> <475906F7.5010309@op5.se> <200712071353.11654.a1426z@gawab.com>
In-Reply-To: <200712071353.11654.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Andreas Ericsson wrote:
>> So, to get to the bottom of this, which of the following workflows is it
>> you want git to support?
>>
>> ### WORKFLOW A ###
>> edit, edit, edit
>> edit, edit, edit
>> edit, edit, edit
>> Oops I made a mistake and need to hop back to "current - 12".
>> edit, edit, edit
>> edit, edit, edit
>> publish everything, similar to just tarring up your workdir and sending
>> out ### END WORKFLOW A ###
>>
>> ### WORKFLOW B ###
>> edit, edit, edit
>> ok this looks good, I want to save a checkpoint here
>> edit, edit, edit
>> looks good again. next checkpoint
>> edit, edit, edit
>> oh crap, back to checkpoint 2
>> edit, edit, edit
>> ooh, that's better. save a checkpoint and publish those checkpoints
>> ### END WORKFLOW B ###
> 
> ### WORKFLOW C ###
> for every save on a gitfs mounted dir, do an implied checkpoint, commit, or 
> publish (should be adjustable), on its privately created on-the-fly 
> repository.
> ### END WORKFLOW C ###
> 

So you *do* want an editor's undo function, but for an entire filesystem.
That's a handy thing to have every now and then, but it's not what git
(or any other scm) does.

> For example:
> 
>   echo "// last comment on this file" >> /gitfs.mounted/file
> 
> should do an implied checkpoint, and make these checkpoints immediately 
> visible under some checkpoint branch of the gitfs mounted dir.
> 
> Note, this way the developer gets version control without even noticing, and 
> works completely transparent to any kind of application.
> 

One other thing that's fairly important to note is that this can never
ever handle changesets, since each write() of each file will be a commit
on its own. It's so far from what git does that I think you'd be better
off just implementing it from scratch, or looking at a versioned fs, like
Jakub suggested in his reply.

You're also neglecting one very important aspect of what an SCM provides
if you go down this road, namely project history. You basically have two
choices with this "implicit save on each edit":
* force the user to supply a commit message for each and every edit
* ignore commit messages altogether

Obviously, forcing a commit message each time is the only way to get some
sort of proper history to look at after it's done, but it's also such an
appalling nuisance that I doubt *anyone* will actually like that, and since
changesets aren't supported, you'll have "implement xniz api, commit 1 of X"
messages. Cumbersome, stupid, and not very useful.

Ignoring commit messages altogether means you ignore the entire history,
and the SCM then becomes a filesystem-wide "undo" cache. This could
ofcourse work, but it's something akin to building a nuclear powerplant
to power a single lightbulb.

-- 
Andreas Ericsson                   andreas.ericsson@op5.se
OP5 AB                             www.op5.se
Tel: +46 8-230225                  Fax: +46 8-230231
