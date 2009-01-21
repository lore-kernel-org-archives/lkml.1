Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbZAUEjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbZAUEjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 23:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbZAUEj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 23:39:29 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:58662 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbZAUEj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 23:39:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fdPbukUFskJzwQ1kbJmH/ehpp8dQuLM1Uy91yWiESjgQohVxuDqrlcMOKVU2O2I1gF
         51xsk8JcIQ+BwlJIwHoUb8v7I++yjhRL8vl6wAjyX7CXrSj/65RIKf8r0+PDtUlPPvwG
         lS43nJjIhDXth3yFjwGUwmb5tHLA71dO6PBVI=
MIME-Version: 1.0
In-Reply-To: <20090117202638.GA11825@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com>
Date: Tue, 20 Jan 2009 23:39:27 -0500
Message-ID: <3e8340490901202039r1ac7e0te5372690dfe81089@mail.gmail.com>
Subject: Re: [PATCH 0/7][v7] Container-init signal semantics
From: Bryan Donlan <bdonlan@gmail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org, daniel@hozac.com, xemul@openvz.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 3:26 PM, Sukadev Bhattiprolu
<sukadev@linux.vnet.ibm.com> wrote:
>
> Container-init must behave like global-init to processes within the
> container and hence it must be immune to unhandled fatal signals from
> within the container (i.e SIG_DFL signals that terminate the process).
>
> But the same container-init must behave like a normal process to
> processes in ancestor namespaces and so if it receives the same fatal
> signal from a process in ancestor namespace, the signal must be
> processed.
>
> Implementing these semantics requires that send_signal() determine pid
> namespace of the sender but since signals can originate from workqueues/
> interrupt-handlers, determining pid namespace of sender may not always
> be possible or safe.
>
> This patchset implements the design/simplified semantics suggested by
> Oleg Nesterov.  The simplified semantics for container-init are:
>
>        - container-init must never be terminated by a signal from a
>          descendant process.
>
>        - container-init must never be immune to SIGKILL from an ancestor
>          namespace (so a process in parent namespace must always be able
>          to terminate a descendant container).
>
>        - container-init may be immune to unhandled fatal signals (like
>          SIGUSR1) even if they are from ancestor namespace (SIGKILL is
>          the only reliable signal from ancestor namespace).

SIGSTOP is normally uncatchable; I note that patch 4 states that
SIGSTOP is allowed through to container-init, but given this summary
is SIGSTOP still reliable when sent to a container-init from an
ancestor namespace?
