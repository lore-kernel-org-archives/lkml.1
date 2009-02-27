Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZB0Hyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZB0Hyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZB0Hyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:54:45 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:53220 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZB0Hyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:54:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ddWMbkbnwK+s5caQtSziga87BuUvRMuGOh6z3VYpqWvkUZB9FJ/pM6mJOFLjYSYfVs
         s4En6L7QJfWb93o5HSqD1jLLSWn1AkiRa83GUE+tG9YswuWcdCn9cU9QMyYal3/kulXw
         7k2vWfhVgO2RrYroDDEhV0CdBKdd99Hceyfc4=
MIME-Version: 1.0
Date: Fri, 27 Feb 2009 08:54:41 +0100
Message-ID: <885896af0902262354v47ddf79ch3d62edaeb1e940bd@mail.gmail.com>
Subject: correct locking in softirq
From: Giacomo <delleceste@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning

Harald Welte's "The journey of a packet through the Linux 2.6.10
network stack" article says that packet travelling inside
linux kernel 2.6 (the receive / input part) runs in softirq context.

Hooking with netfilter's hooks in a kernel module, i need to read for
each packet received a list of rules.

Since in input and prerouting hooks the context is softirq (perhaps
also in forward?), I need some read lock
feature.

I currently use RCU lists and, while reading lists I use

READ

read_lock_bh()

together with list_for_each_rcu()

When changing, or flushing, rules, I use

WRITE

spin_lock() + list_add_tail_rcu() (adding)

or spin_lock() + list_for_each_entry() (for listing and then freeing
with list_del_rcu() and call_rcu() )

The question is:

- is the read part above correct? - do I really need _bh()? or should
I use simply read_lock() ?

Thanks in advance

Giacomo


-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* Aprile 2008: iqfire-wall, un progetto
  open source che implementa un
  filtro di pacchetti di rete per Linux,
  e` disponibile per il download qui:
  http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
  http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
