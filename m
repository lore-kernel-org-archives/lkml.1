Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZKSS5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZKSS5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZKSS5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:57:07 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59488 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZKSS5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:57:06 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH] procfs: make /proc style symlinks behave like "normal" symlinks
References: <1258638251-20034-1-git-send-email-jlayton@redhat.com>
	<m14ooq5tq3.fsf@fess.ebiederm.org>
	<20091119132833.30bc93a4@barsoom.rdu.redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Nov 2009 10:57:08 -0800
In-Reply-To: <20091119132833.30bc93a4@barsoom.rdu.redhat.com> (Jeff Layton's message of "Thu\, 19 Nov 2009 13\:28\:33 -0500")
Message-ID: <m1skca2vi3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

> On Thu, 19 Nov 2009 09:07:16 -0800
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> 
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> This is broken.  If the referenced file is in a different mount namespace
>> the path returned could point to a completely different path in your
>> own mount namespace.  Even in your own mount namespace this makes the
>> proc symlinks racy and not guaranteed to return the file of interest.
>> 
>> I don't see any hope of this approach ever working.
>> 
>> Eric
>> 
>
> Then is proc_pid_readlink broken in the same way?

proc_pid_readlink has the same deficiencies.  The race is fundamental
to all readlink operations, the difference is that for normal symlinks
it is a don't care, and for proc it is incorrect behavior if you follow
the symlink to the wrong file.   If you are dealing with a file in a
different namespace or a socket what you get back doesn't actually
work as a file in your local namespace but that is the best we can do
with a pathname, and if you know the context of what is going on readlink
is still useful.

Adding all of the short comings to followlink that readlink has is a problem,
especially as followlink does much better now.

At a practical level I think your changes are much easier to exploit than
Pavels contrived example.

I really don't have any problems with your first patch to proc to add the
missing revalidate.

Eric
