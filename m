Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZFET5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZFET5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZFET5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:57:31 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:43098 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZFET5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JbQrD5Kv/K+aSkKGdGX7K7+7OjNG2ubwTDTe/u8VmI0HgDS+2DjEvQy1Fuw3i7xwQr
         5YS+9EXaCN4jaj8ZAwYJ9uOTCkSPKxqOoFCOugZXdRou5d7Hc9zNbD0YWcJffSQcgYtt
         iM1FZHZEkDlO9zGASMo+/6nNapIybVDY+W5zM=
MIME-Version: 1.0
In-Reply-To: <4A29723C.2030102@suse.com>
References: <1242496922-6330-1-git-send-email-fweisbec@gmail.com>
	 <1242496922-6330-2-git-send-email-fweisbec@gmail.com>
	 <9b1675090905292005p2b53de7dy9e36f84368d76f01@mail.gmail.com>
	 <4A296343.4050005@suse.com>
	 <9b1675090906051206we136e88k6a14194963726709@mail.gmail.com>
	 <4A29723C.2030102@suse.com>
Date: Fri, 5 Jun 2009 13:57:32 -0600
Message-ID: <9b1675090906051257t5aad47capccfcf1c94f863a66@mail.gmail.com>
Subject: Re: [PATCH 1/2] kill-the-bkl/reiserfs: acquire the inode mutex safely
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll see if I can try that this weekend.

Thanks.

On Fri, Jun 5, 2009 at 1:30 PM, Jeff Mahoney<jeffm@suse.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Trenton D. Adams wrote:
>> FYI: I never did anything specific that I knew of, so I didn't
>> actually notice a delay.  I was rsyncing to a USB key at the time.
>> And seeing it took over an hour, I walked away, so I wouldn't have
>> noticed it.  But, I could fiddle around a little to see if I could get
>> some sort of delay going on.  Any ideas on what I should try?  Then I
>> can do the sysreq+t for you if I can reproduce.
>
> Well if the rsync triggered it, that's a good start.
>
> Try applying the following patch as well. It will cause the hung task detector
> to do a sysrq+t automatically so it's not as much of a guessing game. You'll need to boot with
> hung_task_show_state=1.
>
> - -Jeff
>
> - ---
>  kernel/hung_task.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> - --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -56,6 +56,14 @@ static int __init hung_task_panic_setup(
>  }
>  __setup("hung_task_panic=", hung_task_panic_setup);
>
> +unsigned int __read_mostly sysctl_hung_task_show_state;
> +static int __init hung_task_show_state_setup(char *str)
> +{
> +       sysctl_hung_task_show_state = simple_strtoul(str, NULL, 0);
> +       return 1;
> +}
> +__setup("hung_task_show_state=", hung_task_show_state_setup);
> +
>  static int
>  hung_task_panic(struct notifier_block *this, unsigned long event, void *ptr)
>  {
> @@ -102,6 +110,9 @@ static void check_hung_task(struct task_
>
>        touch_nmi_watchdog();
>
> +       if (sysctl_hung_task_show_state)
> +               show_state();
> +
>        if (sysctl_hung_task_panic)
>                panic("hung_task: blocked tasks");
>  }
>
> - --
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.9 (GNU/Linux)
> Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org
>
> iEYEARECAAYFAkopcjwACgkQLPWxlyuTD7IEdgCfVVzIL/DA0stfnYEW6aixFwxM
> qIEAnjJjyn6HQAbVIicRYzvNcGvPwbiq
> =z8Pn
> -----END PGP SIGNATURE-----
>
