Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbZJSQtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbZJSQtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 12:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZJSQtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 12:49:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:27324 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbZJSQtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 12:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wVEXVeSZJr8qsfo5X0jOTnwZDZdzUpIBUheycIavZmHN3MnmkgOKQ9rB+Ld2G7njF2
         LzHrUSnU75NfFODBnLFJ3eVjRh8heI0kk9A1Kz6lh2uFiC0STEH2ZyBO+8Q7ev2aiCXQ
         eOnaxmHwde68o4KLQE00QiL/bkhGCUGSKqg1Q=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0910191716580.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
	 <1255906474-25091-3-git-send-email-felipe.contreras@gmail.com>
	 <alpine.LSU.2.00.0910191610160.8582@wotan.suse.de>
	 <94a0d4530910190750j5674ef13m93198b68d305b188@mail.gmail.com>
	 <alpine.LSU.2.00.0910191655220.8582@wotan.suse.de>
	 <94a0d4530910190815n4cf2c2ebmd288f6e7501b1ba5@mail.gmail.com>
	 <alpine.LSU.2.00.0910191716580.8582@wotan.suse.de>
Date: Mon, 19 Oct 2009 19:49:27 +0300
Message-ID: <94a0d4530910190949y265426cbq4c32466a9fab8966@mail.gmail.com>
Subject: Re: [PATCH 2/7] ipc: fix trivial warning
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 6:29 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 19 Oct 2009, Felipe Contreras wrote:
>
>> >> >> ipc/msg.c: In function ?msgctl_down?:
>> >> >> ipc/msg.c:415: warning: ?msqid64? may be used uninitialized in this function
>> >> >>
>> >> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> >> >> ---
>> >> >>  ipc/msg.c |    2 +-
>> >> >>  1 files changed, 1 insertions(+), 1 deletions(-)
>> >> >>
>> >> >> diff --git a/ipc/msg.c b/ipc/msg.c
>> >> >> index 2ceab7f..085bd58 100644
>> >> >> --- a/ipc/msg.c
>> >> >> +++ b/ipc/msg.c
>> >> >> @@ -412,7 +412,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
>> >> >>                      struct msqid_ds __user *buf, int version)
>> >> >>  {
>> >> >>       struct kern_ipc_perm *ipcp;
>> >> >> -     struct msqid64_ds msqid64;
>> >> >> +     struct msqid64_ds uninitialized_var(msqid64);
>> >> >>       struct msg_queue *msq;
>> >> >>       int err;
> [ ... snip ... ]
>> > I have verified both with 4.1 and 4.3, and it doesn't emit this
>> > false-positive warning, so there have been gcc versions getting this
>> > right. Ergo gcc developers should rather fix this "regression" and revert
>> > to the old behavior, methinks.
>>
>> The other possibility is that the bug was in gcc 4.1/4.3, and now 4.4
>> finds an actual problem in the code. I will try to dig deeper to see
>> what's actually happening... at first glance I don't see who is
>> initializing msqid64.
>
> This statement of your makes me wonder why you have submitted the patch in
> the first place, as you are apparently not sure whether adding
> uninitialized_var() is a valid thing to do or not.

Because I want to get rid of the warning?

Also, if you look at the commit I mentioned in the commit message
(a0d092f), you'll see this change:
-	struct msq_setbuf uninitialized_var(setbuf);
+	struct msq_setbuf setbuf;

Which is ok, because in that version msgctl_down is calling
audit_ipc_set_perm, directly, but only when cmd == IPC_SET. However,
later on (a5f75e7), ipcctl_pre_down was introduced, and the check was
delegated, and that most probably introduced the warning.

In any case, if the patch is not correct, then somebody should point
that out, which is what the patch review process is for. Alternatively
I could have sent an email asking what is happening here, but from my
point of view this patch serves exactly the same purpose, and has the
advantage that it might turn out to be correct.

It's not as if I didn't do any homework while writing this patch.

> The gcc warning in this case is actually bogus, as msqid64 is touched only
> iff cmd == IPC_SET, and in such case, copy_msqid_from_user() initializes
> it properly.

Yes, but it's used by ipcctl_pre_down, which from what I can see is
only using those arguments when cmd == IPC_SET, so everything is ok.
But still, I don't think the compiler _should_ know what
ipcctl_pre_down is going to do, if you look _only_ at msgctl_down,
then uninitialized_var is OK.

Cheers.

-- 
Felipe Contreras
