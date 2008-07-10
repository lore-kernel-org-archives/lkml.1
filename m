Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYGJIMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYGJIMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYGJIMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:12:20 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:45217 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbYGJIMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:12:18 -0400
Message-ID: <4875C45C.2010901@fastmq.com>
Date: Thu, 10 Jul 2008 10:12:12 +0200
From: Martin Sustrik <sustrik@fastmq.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Martin Lucina <mato@kotelna.sk>, linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk> <20080709222701.8eab4924.akpm@linux-foundation.org>
In-Reply-To: <20080709222701.8eab4924.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------030907010707070008030107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030907010707070008030107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew,

>> we're getting some rather high figures for write(2) latency when testing
>> synchronous writing to disk.  The test I'm running writes 2000 blocks of
>> contiguous data to a raw device, using O_DIRECT and various block sizes
>> down to a minimum of 512 bytes.  
>>
>> The disk is a Seagate ST380817AS SATA connected to an Intel ICH7
>> using ata_piix.  Write caching has been explicitly disabled on the
>> drive, and there is no other activity that should affect the test
>> results (all system filesystems are on a separate drive).  The system is
>> running Debian etch, with a 2.6.24 kernel.
>>
>> Observed results:
>>
>> size=1024, N=2000, took=4.450788 s, thput=3 mb/s seekc=1
>> write: avg=8.388851 max=24.998846 min=8.335624 ms
>> 8 ms: 1992 cases
>> 9 ms: 2 cases
>> 10 ms: 1 cases
>> 14 ms: 1 cases
>> 16 ms: 3 cases
>> 24 ms: 1 cases
> 
> stoopid question 1: are you writing to a regular file, or to /dev/sda?  If
> the former then metadata fetches will introduce glitches.

Not a file, just a raw device.

> stoopid question 2: does the same effect happen with reads?

Dunno. The read is not critical for us. However, I would expect the same 
behaviour (see below).

We've got a satisfying explansation of the behaviour from Roger Heflin:

"You write sector n and n+1, it takes some amount of time for that first 
set of sectors to come under the head, when it does you write it and 
immediately return.   Immediately after that you attempt write sector 
n+2 and n+3 which just a bit ago passed under the head, so you have to 
wait an *ENTIRE* revolution for those sectors to again come under the 
head to be written, another ~8.3ms, and you continue to repeat this with 
each block being written.   If the sector was randomly placed in the 
rotation (ie 50% chance of the disk being off by 1/2 a rotation or 
less-you would have a 4.15 ms average seek time for your test)-but the 
case of sequential sync writes this leaves the sector about as far as 
possible from the head (it just passed under the head)."

Now, the obvious solution was to use AIO to be able to enqueue write 
requests even before the head reaches the end of the sector - thus there 
would be no need for superfluous disk revolvings.

We've actually measured this scenario with kernel AIO (libaio1) and this 
is what we'vew got (see attached graph).

The x axis represents individual write operations, y axis represents 
time. Crosses are operations enqueue times (when write requests were 
issues), circles are times of notifications (when the app was notified 
that the write request was processed).

What we see is that AIO performs rather bad while we are still 
enqueueing more writes (it misses right position on the disk and has to 
do superfluous disk revolvings), however, once we stop enqueueing new 
write request, those already in the queue are processed swiftly.

My guess (I am not a kernel hacker) would be that sync operations on the 
AIO queue are slowing down the retrieval from the queue and thus we miss 
the right place on the disk almost all the time. Once app stops 
enqueueing new write requests there's no contention on the queue and we 
are able to catch up with the speed of disk rotation.

If this is the case, the solution would be straightforward: When 
dequeueing from AIO queue, dequeue *all* the requests in the queue and 
place them into another non-synchronised queue. Getting an element from 
a non-sync queue is matter of few nanoseconds, thus we should be able to 
process it before head missis the right point on the disk. Once the 
non-sync queue is empty, we get *all* the requests from the AIO queue 
again. Etc.

Anyone any opinion on this matter?

Thanks.
Martin

--------------030907010707070008030107
Content-Type: image/png;
 name="aio.png"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="aio.png"

iVBORw0KGgoAAAANSUhEUgAAAeAAAAHgCAMAAABKCk6nAAAABlBMVEUAAAD///+l2Z/dAAAN
4UlEQVR4nO2diZbjKgwFyf//9JzpeA82i5ER11XnvV5BJq4Wwks84QPShN4DAFsQLA6CxUGw
OAgWB8HiIFgcBIuDYHEQLA6CxUGwOAgWB8HiIFgcBIuDYHEQLA6CxUGwOAgWB8HiIFgcBIuD
YHEQLA6CxUGwOAgWB8HiIFgcBIuDYHEQLA6CxUGwOAgWB8HiIFgcBIuDYHEQLA6CxUGwOAgW
B8HiIFgcBIuDYHEQLA6CxUGwOAgWB8HiIFgcBIuDYHEQLA6CxUGwOAgWB8HiIFgcBIuDYHEQ
LA6CxUGwOAgWB8HiIFgcBIuDYHEQLA6CxUGwOAgWB8HiIFgcBIuDYHHKBYcQrrsGMMdQcFg6
nQouDQmlGAreuEVwN8wFb/L4fkgoBsHiWNfg7ycEd8NS8Gdawp0v5RDcnsPS2VRwj5CvZpa7
MYzg8dke9P4YfkQwU7QFu3MZ/z/8CZ729rOCT0eG4GJ2O2/K2e9PP9PXn+6CTUMq85OuYfn0
f19usxfB4/BTYvfpurj9TNoX0d/eBRsyGHv7kDKcl9h9um4ET9oDq2i/hKPXq5z9frdoXcvx
M8fBGdesELzlmK7zD+I5u9bfsJH9s69tz2S1D6nHeYmNTMMH7ev3p3lkO0WnurxYcEaJjeTs
psQmp8dpOwVDuvN6Hgvpm6ISG8vZXK/rFgsGV/OKHg/pl+ISu7V/VmLTWzVp2jGkN+6U2KK5
+Gz7Jk07hnRCwxJ7bychuCXPl9j0kEyadgzZjT4lNj0sk6YdQz5M7xKbHqBJ044hn8FNiU2P
1KRpx5Cm+Cux6SGbNO0Y0oqw8eSoxKbHbdK0Y8i27GbSydX8yUWJTb8Ck6YdQzYhWmJPr9f1
LLFJELzhusRm5awTrSsI/pJRYjeC/ZTYJO8WXFRit790U2KTvFJwZYk9pLdrrwtvEqxYYpO8
RLBsiU0iLfgFJTaJouA3ldgkQoJfWWKTaAh+b4lNMrRgSmyaUQX/5uw7S2ySQQXn5OwrSmyS
MQV/VZ7k7KtKbJJBBU8fDtPwC0tsEgnBLy6xSWwFp3bzPcHHnEVrBEvB864+3+W3avAxZytj
iWMoOES/vBVy7UiJzWRQwR+8ZjKqYMhkzBoM2Yy5ioZsxjwOhmwQLM4jgk9naQSb0yODOZf4
IEzR4iBYHASLg2BxLE9VphdTCDbHNIOTPRBsjvGpyvYhoYwBazAH0CWMJ3i50Q5yGE7wpBbD
mYwnuL7rSwgX3xV0bAKCDUCwOKMLpgYnGFwwq+grfk8djieY4+AEo2cwJECwOAgWB8GvAsHi
IFgcBIuDYHEQLA6CxUGwOAgWB8HijCWYC0nFDCWYS8HljCSYmzkyOO6coQTbDUQHBIuDYHEe
Fbw87bdNSGpwgti7dS0Fh///hauerKKb82AGh7XTWVeOg5sztmBIgmBxnlxkNa/BUM5Iq2io
YKTjYKgAweI8IpjnZPWjRwbztNkHYYoWB8Hi2ArmH+V4mN8danqiI+w/NwgJ1zwqOES/vBUS
EiBYnJEFc1iVIH7sOUwN5mJ/Ds8uslquorldJ4unBbcLyQ13WSBYHAS/jmEEU4PrGEUwq+hK
hhHMcXAd4wiGKhAsDoJ1iO5NBOuAYHEQLA6ChTm9TxXBOpDB4iBYHASLg+A3gmBxECzOEIK5
UpjByQ6qFfx/j9/f53kRuNafQ1vBYf7vHlkBuFsni6aCw+b/O+QJLmn8XhAszMUTEywFz09R
Om+F4HY8X4PD/kP11qnBWbRfRaf2+CbFz1qyim5HY8GZ7ZsI5jg4h5EFQz21NTjnOVeL4Xs1
GO5Qv4rO6ZH6M0BwK1rkULngkpBwCwSL01hwoRkeRmpOc8F3HibKw0jbcrk3maI1oAaL00kw
DyN9ii6LLB5G+hytMzhnkZSR8Qg2x/hcdKIrgptwtRsRLEAnwU1qMEfLGTQW/P+G2cwTFbdX
0Vzrz6FXBt8Pyd06SVK5du84+O6OTwputB1x2mcwgl3RWnC7awUIboJdBt+FGtyA6zeJ+V5k
sYrO4HrvOBfMcXCasQVDEgQLk17uInh4yGBxEKxMQLA2CBYnfSahYaxyEHwXBAtTemdcMt7d
AT0S8mWQweIgWJqMpw0ieGQQLE7G/vMsmEuFKcYWzMX+SzLvm/IrmNt10gydwdxwlyLrid0I
Hhcvgi/6IfgOowumBifI2jOGgjcP0znryiq6luz3HlgKTvfjOPgOvTN4mWQbhoSZ5K0ca7uC
kMWjCNf9EFyND8F/ihFsgRfB18skBFeTu+v8nuiAU0revvuIYJ4225r8f1ewRwbztNnb+BZs
GvIdIFiYsunP+jiYp80aUPIv+z5wJounzbbGieAQ/fJWSPgDweIgWJjSI0ynNZiD5FNyT0Kv
zQ2aLl0qV9Fc6z/HleDKkNytc4GEYLstjk3FKV4Ej0XJAnrqYNH0ZkgEnyIimBocJ4gIZhUd
peoiq0/BHAfHKc5ft4IhCoKFqbwLBsHDEMhgbQpPYa29DJp2DKlKQLAy9behIngQKsrv1M+i
aceQmlScwlp6WjTtGFKRO+8TQLB/AhmsTd0B8NrZoGnHkHrceyMXgr0T1DKYC0lbbr8P051g
LgXvCNWnsJYAFk3rQ3Izxx49wXYbG48Wb5RHsGNuHQCvMQya1odE8EKbB12YCl7GdnpzXaTL
9tOruXl8tESxaLp2CJddWUWf0exBNYaCN24LBHMc/EdYMvh+IIOm2/ZrHt8P+RYaPmgKwR5p
U36nUBZNdx0uJhoEx2j6nDjjVfT0CcHZrMe+bXaOt+Pg19Ow/H7jmTTtGHJswiaDW0W0aHrs
yRSdRWhbfqeYFk0Tgdq/DA0s9gtTtBe2qysEyxGs5jVbwanxIvjLvvgOI5inzWaxn5tb7xL7
U5VXXRH8+Qq2W3UiuDP74isu+H1HTobFd9mCRdOpQ2ENftu1/v3cbPS6Ha2iX3a3znZZZbG6
WjZj0bQqZIj9UJRgX3zXLRk0rQr5FsFz1hoX32VrFk2rQr5C8DwfP5G88wYNmlaFfEENDg/O
zcsmLZrWhVRfRUfn5jcJFj4O/k3d0PC2nOstWzTtGNIjv6n7SPJO27Zo2jGkO6LLqkeSd968
QdOOIV0Rfudm07Ma0SFYNO0Y0gshkrqPzs3LOCyadgzpAwepu4zEomnHkN3ZnWPumLrLcCya
dgzZk1Xj78z83LLqOCaLph1DdiJEp+VN6vZ6qQi+z/6aX6Tq9nyZCL7Bwayv1F3GaNG0Y8iH
+Llcv3O7/U33gVo07RjSmsiNGL9uPaTuBIJziZmNr5U7V909CE6yFxczG47yHeFG8DTBeeIn
XS/OPbqalrd4EeznYn9sIo5n7U8DjzgR3P92nbjSTLM+3f7hRbDdNlIDiJfYbLOO3f7xTsEn
6ZpcQ41kduI9gi9m4NXfkdO/gGGwFTzPbMmQJjX4Yuq9StfdEe2P4NGwFFzy5rM2q+j01Lv9
9KP18g9hUAwFh+iXp01qjoNTc25M8EW6SpmdcCM4J15mZkbaRbSm40ngVXB5Ziby9LK2buOJ
4aUGV2ZmSml+PFWcrKI/5YLPkrQo0/WxFVwS8lLIOcWZbvJC/OJRcLbNrEx/T7JGeURw8mmz
2ZNtkWD49MngncRN+HuLLJRG8ThF5wuGJAMJhhq8HiZBI/yc6AATDAWH6Je3QkIxCBYHweJQ
g8Xxs4oGE/wcB4MJnQWDNSU22gs22Kxtc1+jaWwEwebhEdy7ua/RILh5c1+jQXDz5r5Gg+Dm
zX2NBsHNm/saDYKbN/c1GgQ3b+5rNAhu3tzXaDQEw1MgWBwEi4NgcRAsDoLFQbA4CBYHweIg
WBwEi4NgcRAsDoLFQbA4fQSX3Zx/9U63k+hF9/6XtF7eepfXp655yycwdxEcCjdc9jSPsHww
GEwo61PVvPD1ZoV8lLD5mNmhOMeyO5Q1D2XGwuaPLaN9eKngUPjXYDeY8CkyVte88PUmg/bC
TnD52+8Kp+j8P4oQ/TLRXEOwVZGc/h2BkpEUL7JqBOfX4NLx547gWQr3qV0NfiiDC1bRCoIr
cya/vdUiq1Jw7utd3A4uuPiotuTI1qHgougV7+JPj+BZKrbpK4MLD2wLC0BZl+yQD2IruKZm
lypA8PU2y+eg0kndrPlSVEtWTdmvV0QwPAiCxUGwOAgWB8HiIFgcBIuDYHEQLA6CxUGwOAgW
B8HiIFgcBIuDYHEQLA6CxUGwOAgWB8HiIFgcBIuDYHEQLA6CxUGwOAgWZ3DBoeApCS1e6ni7
a7wR7ygVfOflpvoHl3vT4ZBKCKffZLS/s6347x3uTYdDyuX/W27D+tiDw7utw/bD/0cr/X3+
vk13/2bdMD+ubPnx5ifTu3vnbYRjh00gBLflu9PX/Rr2c+he8Pyr5af7iX2Otf/95oFMIfb/
/g+q6ZM12uFvRJksO34neJ9Qn6jXsOm/jxP94hjst90n0sENHseUxU7w/E3YN1gm7ruCA4If
Z7+fY6V1k9SHmXc7mUa8zr+ffjLXXgQ/yjHPwnGK/tO7fRzoPoNP4oS9skgNjgv2WoI1BK81
eF83rwTnTtGZgr0msM9BZfGdbY+C94Z3Fn7m6n2ryCp67RoOP47+objcly4HlUf8ODii7ldV
7nHwZ449dZtjHHJ7+uxyX7ocVBdE94Toy6pAdE+IvqwKRPeE6MuqQHRPiL4smEGwOAgWB8Hi
IFgcBIuDYHEQLA6CxUGwOAgWB8HiIFgcBIuDYHEQLA6CxUGwOAgWB8Hi/AO+pGuI2szBKAAA
AABJRU5ErkJggg==
--------------030907010707070008030107--
