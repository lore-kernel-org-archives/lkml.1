Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246Ab0AESbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0AESbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745Ab0AESbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:31:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab0AESbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:31:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] BUG(): CONFIG_BUG=n version of BUG() should be unreachable()
Date: Tue, 5 Jan 2010 19:30:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       David Daney <ddaney@caviumnetworks.com>
References: <20091226184722.GA25275@merkur.ravnborg.org> <1261531032-15225-1-git-send-email-a.beregalov@gmail.com> <9664.1262714298@redhat.com>
In-Reply-To: <9664.1262714298@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001051930.23532.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/yvVV+9YxhsdaTBPMJe7AYB04sYSJVP+hP7jm
 JMR/r5hqJxX6/ICwjedx0IfMcqTU9wHxtMiuE+lkOfa8nMYgA/
 ojMU4qBPRK9kbRpFq/xwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, David Howells wrote:
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > +#define BUG() do {                                                   \
> > +             for (;;)                                                \
> > +                     /* endless loop*/;                              \
> > +             unreachable();                                          \
> > +} while(0)
> 
> Can you not do:
> 
>         #define BUG() do {                                              \
>                         unreachable();                                  \
>         } while(1)
> 
> instead?  If the compiler is interpreting unreachable() to really mean that
> what comes after will not be reached, then the condition/loop at the end of
> the block should be optimised away.

Forcing the loop here is really wrong because it needlessly
causes extra code to be emitted. We don't really want controlled
error handling here (that is the definition of CONFIG_BUG=n),
so this is only about shutting up the compiler warning.

I guess the best would be something like
#if defined (__GNUC__) && (__GNUC_MAJOR__ == 4) && (__GNUC_MINOR__ >= 5)
#define BUG() __builtin_unreachable()
#else
#define BUG() do { } while (0) /* this may cause a warning */
#endif

I still haven't found out how many warnings we are talking about
here, maybe we can just silence them by adding individual
unreachable() statements after BUG();

	Arnd
